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
      CSV.parse(data,
                converters:        [->(f) { f ? f.strip : nil }, :date, :numeric],
                headers:           true,
                header_converters: [->(f) { convert_header(f) }],
                skip_blanks:       true) do |row|
        klass.create(row.to_hash.slice(*yaml_dictionary.keys))
      end
      klass.refresh_index!
    end
  end

  def yaml_dictionary
    YAML.load dictionary
  end

  def filter_fields
    fields_of_type 'enum'
  end

  def fulltext_fields
    fields_of_type 'string'
  end

  def date_fields
    fields_of_type 'date'
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

  def self.id_from_params(api, version_number)
    [api, ['v', version_number || '1'].join].join(':')
  end

  def self.directory
    all(_source: { exclude: ['data'] }, sort: [{ api: { order: :asc } }, { version_number: { order: :asc } }]) rescue []
  end

  private

  def delete_api_index
    ES.client.indices.delete(index: [ES::INDEX_PREFIX, 'api_models', api, "v#{version_number}"].join(':'), ignore: 404)
    DataSource.refresh_index!
  end

  def build_dictionary
    parser = DataSourceParser.new(data)
    @dictionary = parser.generate_dictionary.to_yaml
  end

  def convert_header(source)
    yaml_dictionary.find { |entry| entry.last[:source] == source }.first rescue '*DELETED FIELD*'
  end

  def fields_of_type(type)
    Hash[yaml_dictionary.find_all { |entry| entry.last[:type] == type && entry.last[:indexed] == true }.map { |entry| [entry.first, entry.last[:description]] }]
  end
end
