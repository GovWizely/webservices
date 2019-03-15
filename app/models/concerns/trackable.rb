module Trackable
  extend ActiveSupport::Concern

  module ClassMethods
    def find_or_create_metadata
      if MetadataRepository.exists? index_name
        MetadataRepository.find index_name
      else
        metadata = Metadata.new id: index_name,
                                import_rate: import_rate,
                                source: source[:full_name] || source[:code]
        MetadataRepository.save metadata
        ES.client.indices.refresh index: index_name
        metadata
      end
    end

    def update_metadata(version, time = DateTime.now.utc)
      metadata = find_or_create_metadata
      MetadataRepository.update id: metadata.id,
                                import_rate: import_rate,
                                source: source[:full_name] || source[:code],
                                source_last_updated: time,
                                last_imported: time,
                                version: version
      ES.client.indices.refresh index: MetadataRepository.index_name
    end

    def touch_metadata(time = DateTime.now.utc)
      metadata = find_or_create_metadata
      MetadataRepository.update id: metadata.id,
                                import_rate: import_rate,
                                source: source[:full_name] || source[:code],
                                last_imported: time
      ES.client.indices.refresh index: MetadataRepository.index_name
    end

    def delete_metadata
      MetadataRepository.delete(index_name) if MetadataRepository.exists?(index_name)
    end
  end
end
