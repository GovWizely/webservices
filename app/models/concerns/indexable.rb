module Indexable
  extend ActiveSupport::Concern

  # We include Searchable as a dependency, which provides the ability to search
  # for docs via the index defined by is module.
  include Searchable

  included do
    class << self
      attr_accessor :mappings, :settings
    end
  end

  module ClassMethods
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
    end

    def update_metadata(version)
      ES.client.index(
        index: index_name,
        type:  'metadata',
        id:    0,
        body:  { version: version, time: DateTime.now.utc })
    end

    def stored_metadata
      ES.client.search(
        index: index_name,
        type:  'metadata',
        body:  { query: { match: { _id: 0 } } })['hits']['hits'][0]['_source'].symbolize_keys rescue {}
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

      ES.client.delete_by_query(index: index_name, body: body)
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

    # This overwrites index_names in Searchable, making searches by classes
    # which include Indexable focus only on the index defined by the class.
    def index_names(_sources = nil)
      [index_name]
    end
  end
end
