class MetadataRepository
  include Elasticsearch::Persistence::Repository

  klass Metadata

  settings number_of_shards: 1 do
    mapping dynamic: false do
      indexes :id
      indexes :source
      indexes :source_last_updated, type: :date
      indexes :last_imported, type: :date
      indexes :version
      indexes :import_rate
    end
  end

  index [ES::INDEX_PREFIX, Metadata.name.indexize].join(':')
  client ES.client
end
