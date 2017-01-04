module DataSources
  module Findable
    extend ActiveSupport::Concern

    module ClassMethods
      def id_from_params(api, version_number)
        [api, ['v', version_number || '1'].join].join(':')
      end

      def find_published(api, version_number, exclude_data = true)
        versioned_id = id_from_params(api, version_number)
        query_hash = { query: { bool: { filter: [{ term: { _id: versioned_id } }, { term: { published: true } }] } } }
        query_hash[:_source] = { excludes: ['data'] } if exclude_data
        search(query_hash).first
      end

      def directory
        all(_source: { excludes: %w(data dictionary) }, sort: [{ api: { order: :asc } }, { version_number: { order: :asc } }])
      end

      def api_versions(api)
        search(query:   { constant_score: { filter: { term: { api: api } } } },
               _source: { includes: ['version_number'] },
               sort:    :version_number,).collect(&:version_number)
      end

      def current_version(api)
        current_version = new(api: api).versions.last
        find_published(api, current_version, false)
      end
    end

    def oldest_version?
      version_number == versions.first
    end

    def newest_version?
      version_number == versions.last
    end

    def versions
      @versions ||= self.class.api_versions(api)
    end
  end
end
