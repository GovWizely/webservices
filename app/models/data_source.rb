require 'elasticsearch/persistence/model'
require 'api_models'
class DataSource
  include Elasticsearch::Persistence::Model

  VALID_CONTENT_TYPES = %w(text/csv text/plain text/tab-separated-values text/xml application/xml application/vnd.ms-excel).freeze

  index_name [ES::INDEX_PREFIX, name.indexize].join(':')
  attribute :name, String, mapping: { type: 'string', analyzer: 'english' }
  validates :name, presence: true
  attribute :api, String, mapping: { type: 'string', index: 'not_analyzed' }
  validates :api, presence: true, format: { with: /\A[a-z0-9_]+\z/ }, reserved_api: true
  attribute :description, String, mapping: { type: 'string', analyzer: 'english' }
  attribute :dictionary, String, mapping: { type: 'string', index: 'no' }
  attribute :data, String, mapping: { type: 'string', index: 'no' }
  validates :data, presence: true
  attribute :version_number, Integer
  validates :version_number, numericality: true, presence: true
  attribute :published, Boolean

  before_save :build_dictionary
  after_update :refresh_metadata
  after_destroy :delete_api_index

  def initialize(attributes = {})
    attributes.merge!(_id: DataSource.id_from_params(attributes['api'], attributes['version_number'])) if
      id.nil? && attributes['api'].present? && attributes['version_number'].present?
    super(attributes)
  end

  def with_api_model
    klass = ModelBuilder.load_model_class(self)
    klass_symbol = api.classify.to_sym
    Webservices::ApiModels.redefine_model_constant(klass_symbol, klass)
    yield klass
  end

  def ingest
    delete_api_index
    with_api_model do |klass|
      klass.create_index!
      "DataSources::#{data_format}Ingester".constantize.new(klass, metadata, data).ingest
      klass.refresh_index!
    end
  end

  def metadata
    @metadata ||= DataSources::Metadata.new(dictionary)
  end

  def oldest_version?
    version_number == versions.first
  end

  def newest_version?
    version_number == versions.last
  end

  def versions
    @versions ||= DataSource.search(query:   { filtered: { filter: { term: { api: api } } } },
                                    _source: { include: ['version_number'] },
                                    sort:    :version_number).collect(&:version_number)
  end

  def search_params
    fulltext_field_keys = metadata.fulltext_fields.present? ? %i(q) : []
    metadata.non_fulltext_fields.keys + fulltext_field_keys
  end

  def self.id_from_params(api, version_number)
    [api, ['v', version_number || '1'].join].join(':')
  end

  def self.find_published(api, version_number)
    versioned_id = id_from_params(api, version_number)
    query_hash = { filter: { and: [{ term: { _id: versioned_id } }, { term: { published: true } }] } }
    search(query_hash, _source: { exclude: ['data'] }).first
  end

  def self.directory
    all(_source: { exclude: ['data'] }, sort: [{ api: { order: :asc } }, { version_number: { order: :asc } }]) rescue []
  end

  private

  def delete_api_index
    ES.client.indices.delete(index: [ES::INDEX_PREFIX, 'api_models', api, "v#{version_number}"].join(':'), ignore: 404)
    DataSource.refresh_index!
  end

  def data_format
    case data
      when /\A<\?xml /
        'XML'
      when /\t/
        'TSV'
      else
        'CSV'
    end
  end

  def build_dictionary
    @dictionary = "DataSources::#{data_format}Parser".constantize.new(data).generate_dictionary.to_yaml
    refresh_metadata
  end

  def refresh_metadata
    @metadata = nil
  end
end
