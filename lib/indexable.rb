module Indexable
  attr_accessor :default_sort, :mappings, :settings
  attr_writer :index_name, :index_type

  def index_name
    assign_index_name unless defined?(@index_name)
    @index_name
  end

  def index_type
    assign_index_type unless defined?(@index_type)
    @index_type
  end

  def delete_index
    ES::client.indices.delete index: index_name
  end

  def create_index
    ES::client.indices.create(
        index: index_name,
        body: { settings: settings, mappings: mappings })
  end

  def index_exists?
    ES::client.indices.exists index: index_name
  end

  def recreate_index
    delete_index if index_exists?
    create_index
  end

  def index(records)
    records.each do |record|
      hash = { index: index_name, type: index_type, id: record[:id], body: record.except(:id, :ttl) }
      hash.merge!(ttl: record[:ttl]) if record[:ttl]
      ES::client.index(hash)
    end
    ES::client.indices.refresh index: index_name
    Rails.logger.info "Imported #{records.size} entries to index #{index_name}"
  end

  def search_for(options)
    klass = "#{self.name}Query".constantize
    query = klass.new options
    hits = ES::client.search(
        index: index_name,
        type: index_type,
        body: query.generate_search_body,
        from: query.offset,
        size: query.size,
        sort: query.sort)['hits'].deep_symbolize_keys
    hits[:offset] = query.offset
    hits.deep_symbolize_keys
  end

  private

  def assign_index_name
    self.index_name = [ES::INDEX_PREFIX, self.name.tableize].join(':').freeze
  end

  def assign_index_type
    self.index_type = self.name.underscore.freeze
  end
end
