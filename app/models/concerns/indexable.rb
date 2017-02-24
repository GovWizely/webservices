module Indexable
  extend ActiveSupport::Concern

  # We include Searchable as a dependency, which provides the ability to search
  # for docs via the index defined by is module.
  include Findable
  include Searchable

  included do
    class << self
      attr_accessor :mappings, :settings, :source, :import_rate
      def metadata_mappings
        {
          metadata: {
            properties: {
              last_imported: {
                type: 'keyword',
              },
              last_updated:  {
                type: 'keyword',
              },
              version:       {
                type: 'keyword',
              },
              import_rate:   {
                type: 'keyword',
              },
            },
          },
        }
      end
    end

    # If the model class doesn't define the source full_name,
    # default to the class name. This gets used when reporting
    # which sources were used in a search and when was that
    # source last updated.
    self.source = { full_name: name, code: name }
  end

  module ClassMethods
    def analyze_by(*analyzers)
      self.settings ||= {
        index: {
          analysis: { analyzer: {}, filter: {} },
        },
      }
      analyzers.each do |analyzer|
        self.settings[:index][:analysis][:analyzer][analyzer] = Analyzers.definitions[analyzer]
      end
    end

    def index_name
      @index_name ||= [ES::INDEX_PREFIX, name.indexize].join(':')
    end

    def index_type
      @index_type ||= name.typeize
    end

    def delete_index
      ES.client.indices.delete index: index_name
    end

    def create_index
      ES.client.indices.create(
        index: index_name,
        body:  { settings: settings, mappings: mappings },)
      initialize_metadata
    end

    def update_metadata(version, time = DateTime.now.utc)
      _update_metadata(version: version, last_updated: time, last_imported: time)
    end

    def touch_metadata(import_time = DateTime.now.utc)
      _update_metadata(stored_metadata.merge(last_imported: import_time))
    end

    def initialize_metadata
      _update_metadata(EMPTY_METADATA)
    end

    def _update_metadata(body)
      body[:import_rate] = import_rate.nil? ? '' : import_rate
      ES.client.index(
        index: index_name,
        type:  'metadata',
        id:    0,
        body:  body,)
      ES.client.indices.refresh index: index_name
    end

    # If any field is not present, we initialize it with those values.
    EMPTY_METADATA = { version: '', last_updated: '', last_imported: '', import_rate: '' }

    def stored_metadata
      normalize_metadata ES.client.get(index: index_name, type: 'metadata', id: 0)['_source'].symbolize_keys
    end

    def normalize_metadata(metadata)
      EMPTY_METADATA.merge metadata
    end

    def index_exists?
      ES.client.indices.exists index: index_name
    end

    def recreate_index
      delete_index if index_exists?
      create_index
    end

    def index(records)
      records.each { |record| ES.client.index(prepare_record_for_indexing(record)) }
      ES.client.indices.refresh(index: index_name)

      Rails.logger.info "Imported #{records.size} entries to index #{index_name}"
    end

    def update(records)
      records.each { |record| ES.client.update(prepare_record_for_updating(record)) }
      ES.client.indices.refresh(index: index_name)
    end

    def purge_old(before_time)
      raise 'This model is unable to purge old documents' unless can_purge_old?
      body = Utils.older_than(:_updated_at, before_time)
      ES.client.delete_by_query(index: index_name, type: index_type, body: body)
      ES.client.indices.refresh(index: index_name)
    end

    def can_purge_old?
      mappings[name.typeize][:properties][:_updated_at].present?
    end

    def importer_class
      "#{name}Data".constantize
    end

    private

    def prepare_record_for_indexing(record)
      {
        index: index_name,
        type:  index_type,
        id:    record[:id],
        body:  prepare_record(record),
      }
    end

    def prepare_record_for_updating(record)
      {
        index: index_name,
        type:  index_type,
        id:    record[:id],
        body:  { doc: prepare_record(record) },
      }
    end

    def prepare_record(record)
      record.except(:id).reverse_merge(_updated_at: Time.now.utc.iso8601(8))
    end
  end
end
