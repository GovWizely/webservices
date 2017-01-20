require 'elasticsearch/persistence/model'
require 'api_models'
require 'registry'
class DataSource
  include DataSources::Findable
  include DataSources::Indexable
  include Elasticsearch::Persistence::Model

  VALID_CONTENT_TYPES = %w(text/csv text/plain text/tab-separated-values text/xml application/xml application/vnd.ms-excel application/json).freeze

  index_name [ES::INDEX_PREFIX, name.indexize].join(':')
  attribute :name, String, mapping: { type: 'text', analyzer: 'english' }
  validates :name, presence: true
  attribute :api, String, mapping: { type: 'keyword' }
  validates :api, presence: true, format: { with: /\A[a-z0-9_]+\z/ }, reserved_api: true
  attribute :description, String, mapping: { type: 'text', analyzer: 'english' }
  attribute :dictionary, String, mapping: { type: 'text', index: 'no' }
  attribute :data, String, mapping: { type: 'text', index: 'no' }
  attribute :version_number, Integer
  validates :version_number, numericality: true, presence: true
  attribute :published, Boolean
  attribute :consolidated, Boolean
  attribute :url, String, mapping: { type: 'text', index: 'no' }
  attribute :message_digest, String, mapping: { type: 'text', index: 'no' }
  attribute :data_changed_at, DateTime
  attribute :data_imported_at, DateTime

  before_save :build_dictionary, :initialize_timestamps
  after_update :refresh_metadata
  after_destroy :delete_api_index

  def initialize(attributes = {})
    attributes[:_id] = DataSource.id_from_params(attributes['api'], attributes['version_number']) if id.nil? && attributes['api'].present? && attributes['version_number'].present?
    super(attributes)
  end

  def with_api_model
    klass = ModelBuilder.load_model_class(self)
    klass_symbol = api.classify.to_sym
    Webservices::ApiModels.redefine_model_constant(klass_symbol, klass)
    yield klass
  end

  def with_api_models(sources_param)
    Elasticsearch::Model::Registry.clear
    klasses = consolidated_data_sources(sources_param).collect do |source|
      klass = ModelBuilder.load_model_class(source)
      klass_symbol = source.api.classify.to_sym
      Webservices::ApiModels.redefine_model_constant(klass_symbol, klass)
      Elasticsearch::Model::Registry.add klass
      klass
    end
    yield klasses
  end

  def metadata
    metadata_dictionary = is_consolidated? ? sources_map.values.first.dictionary : dictionary
    @metadata ||= DataSources::Metadata.new(metadata_dictionary)
  end

  def sources_map
    @sources_map ||= YAML.load(dictionary).collect do |e|
      published_data_source = DataSource.find_published(e['api'], e['version_number'])
      [e['source'], published_data_source] if published_data_source.present?
    end.compact.to_h
  end

  def consolidated_data_sources(whitelist)
    sources_array = whitelist.present? ? whitelist.split(',').collect(&:strip) : sources_map.keys
    whitelisted_data_sources = sources_map.slice(*sources_array)
    whitelisted_data_sources.any? ? whitelisted_data_sources.values : sources_map.values
  end

  def is_consolidated?
    consolidated.present? && consolidated == true
  end

  def search_params
    fulltext_field_keys = metadata.fulltext_fields.present? ? %i(q) : []
    sources = is_consolidated? ? %i(sources) : []
    metadata.non_fulltext_fields.keys + fulltext_field_keys + sources
  end

  private

  def build_dictionary
    @dictionary = generate_yaml_dictionary unless is_consolidated?
    refresh_metadata
  end

  def generate_yaml_dictionary
    "DataSources::#{data_format}Parser".constantize.new(data).generate_dictionary.to_yaml
  end

  def refresh_metadata
    @metadata = nil
    @sources_map = nil
  end
end
