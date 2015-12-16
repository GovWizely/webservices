require 'elasticsearch/persistence/model'
require 'api_models'
class DataSource
  include Elasticsearch::Persistence::Model
  VALID_CONTENT_TYPES = %w(text/csv text/plain).freeze

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
  after_destroy :delete_api_index

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
      ingest_csv(klass)
      klass.refresh_index!
    end
  end

  def ingest_csv(klass)
    ingest_csv_options = { converters:        [->(f) { f ? f.squish : nil }, :date, :numeric],
                           header_converters: [->(f) { convert_header(f) }],
                           headers:           true,
                           skip_blanks:       true }
    CSV.parse(data, ingest_csv_options) { |row| klass.create(transform(row.to_hash.slice(*yaml_dictionary.keys))) }
  end

  def yaml_dictionary
    YAML.load dictionary
  end

  def filter_fields
    fields_matching_hash type: 'enum'
  end

  def plural_filter_fields
    fields_matching_hash type: 'enum', indexed: true, plural: true
  end

  def pluralized_filter_fields
    plural_filter_fields.map { |singular_key, value| [singular_key.to_s.pluralize.to_sym, value] }.to_h
  end

  def singular_filter_fields
    fields_matching_hash type: 'enum', indexed: true, plural: false
  end

  def fulltext_fields
    fields_matching_hash type: 'string', indexed: true
  end

  def date_fields
    fields_matching_hash type: 'date', indexed: true
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
    fulltext_field_keys = fulltext_fields.present? ? %i(q) : []
    pluralized_filter_fields.keys + singular_filter_fields.keys + fulltext_field_keys + date_fields.keys
  end

  def self.id_from_params(api, version_number)
    [api, ['v', version_number || '1'].join].join(':')
  end

  def self.directory
    all(_source: { exclude: ['data'] }, sort: [{ api: { order: :asc } }, { version_number: { order: :asc } }]) rescue []
  end

  private

  def transform(hash)
    hash.keys.collect { |field_sym| [field_sym, transformers[field_sym].transform(hash[field_sym])] }.to_h
  end

  def delete_api_index
    ES.client.indices.delete(index: [ES::INDEX_PREFIX, 'api_models', api, "v#{version_number}"].join(':'), ignore: 404)
    DataSource.refresh_index!
  end

  def build_dictionary
    parser = DataSourceParser.new(data)
    @dictionary = parser.generate_dictionary.to_yaml
  end

  def transformers
    yaml_dictionary.map { |field, meta| [field, DataSources::Transformer.new(meta)] }.to_h
  end

  def convert_header(source)
    yaml_dictionary.detect { |_, meta| meta[:source] == source }.first rescue '*DELETED FIELD*'
  end

  def fields_matching_hash(hash)
    yaml_dictionary.find_all { |_, meta| meta.include_hash?(hash) }.map { |field, meta| [field, meta[:description]] }.to_h
  end
end
