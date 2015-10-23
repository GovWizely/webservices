module Indexable
  extend ActiveSupport::Concern

  # We include Searchable as a dependency, which provides the ability to search
  # for docs via the index defined by is module.
  include Searchable

  included do
    class << self
      attr_accessor :mappings, :settings, :source
      def metadata_mappings
        {
          metadata: {
            properties: {
              last_imported: {
                type: 'string',
              },
              last_updated:  {
                type: 'string',
              },
              version:       {
                type: 'string',
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
        body:  { settings: settings, mappings: mappings })
      touch_metadata
    end

    def update_metadata(version, time = DateTime.now.utc)
      _update_metadata(version: version, last_updated: time, last_imported: time)
    end

    def touch_metadata(import_time = DateTime.now.utc)
      _update_metadata(stored_metadata.merge(last_imported: import_time))
    end

    def _update_metadata(body)
      ES.client.index(
        index: index_name,
        type:  'metadata',
        id:    0,
        body:  body)
    end

    # If any field is not present, we initialize it with those values.
    EMPTY_METADATA = { version: '', last_updated: '', last_imported: '' }

    def stored_metadata
      stored = ES.client.get(
        index: index_name,
        type:  'metadata',
        id:    0,
      )['_source'].symbolize_keys rescue {}

      EMPTY_METADATA.merge(stored)
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
      fail 'This model is unable to purge old documents' unless can_purge_old?
      body = {
        query: {
          filtered: {
            filter: {
              range: {
                _timestamp: {
                  lt: (before_time.to_f * 1000.0).to_i,
                },
              },
            },
          },
        },
      }

      ES.client.delete_by_query(index: index_name, type: index_type, body: body)
    end

    def can_purge_old?
      timestamp_field = mappings[name.typeize][:_timestamp]
      timestamp_field && timestamp_field[:enabled] && timestamp_field[:store]
    end

    def importer_class
      "#{name}Data".constantize
    end

    private

    def prepare_record_for_indexing(record)
      prepared = {
        index: index_name,
        type:  index_type,
        id:    record[:id],
        body:  record.except(:id, :ttl, :timestamp),
      }
      prepared.merge!(ttl: record[:ttl]) if record[:ttl]
      prepared.merge!(timestamp: record[:timestamp]) if record[:timestamp]
      prepared
    end

    def prepare_record_for_updating(record)
      {
        index: index_name,
        type:  index_type,
        id:    record[:id],
        body:  { doc: record.except(:id) },
      }
    end
  end
end
