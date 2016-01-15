class Query
  include ActiveModel::Validations

  class InvalidParamsException < Exception
    attr_accessor :errors
  end

  DEFAULT_SIZE = 10.freeze
  MAX_SIZE = 100.freeze
  attr_accessor :offset, :size, :sort, :q, :search_type

  validates_numericality_of :offset, greater_than_or_equal_to: 0, allow_nil: true

  class_attribute :aggregation_terms
  self.aggregation_terms = {}

  def self.aggregate_terms_by(terms)
    self.aggregation_terms = terms
  end

  def self.query_fields=(value)
    class_variable_set('@@fields', value)
  end

  def self.query_fields
    class_variable_get('@@fields') rescue nil
  end

  def query_fields
    self.class.query_fields
  end

  def self.setup_query(fields)
    fields.reverse_merge!(query: [], filter: [], sort: [])
    fields[:query].each { |f| attr_reader f }
    fields[:filter].each { |f| attr_reader f }
    self.query_fields = fields
  end

  def initialize(options = {})
    options.delete_if { |_k, v| v == '' }
    options.reverse_merge!(size: DEFAULT_SIZE)

    cleanup_invalid_bytes(options, [:q])

    @offset = options[:offset].to_i
    @size = [options[:size].to_i, MAX_SIZE].min
    @q = options[:q]
    initialize_search_fields(options)

    unless valid?
      e = InvalidParamsException.new
      e.errors = errors.to_a
      fail e
    end
  end

  def initialize_search_fields(options)
    if query_fields
      query_fields[:query].each { |f| instance_variable_set("@#{f}", options[f]) }
      query_fields[:filter].each { |f| instance_variable_set("@#{f}", options[f]) }
      instance_variable_set('@sort', query_fields[:sort].try(:join, ',')) unless q
    end
  end

  def generate_search_body
    Jbuilder.encode do |json|
      generate_query(json)
      generate_filter(json)
      generate_aggregations(json)
    end
  end

  def generate_search_body_hash
    Jbuilder.new do |json|
      generate_from_size_sort(json)
      generate_query(json)
      generate_filter(json)
      generate_aggregations(json)
    end.attributes!
  end

  def generate_multi_match(json, fields, query, operator = :and)
    json.multi_match do
      json.fields fields
      json.operator operator
      json.query query
    end if query
  end

  def generate_multi_match_query(json, multi_fields, query)
    json.query do
      generate_multi_match(json, multi_fields, query)
    end if query
  end

  def generate_match(json, field, query, operator = :and)
    json.match do
      json.set! field do
        json.operator operator
        json.query query
      end
    end if query
  end

  def generate_terms(json, field, filter_value)
    json.terms { json.set! field, filter_value }
  end

  def query_from_fields(json, fields)
    json.query do
      json.bool do
        json.must do
          fields[:query].each do |field|
            search = send(field)
            json.child! { generate_match(json, field, search) } if search
          end
          json.child! { generate_multi_match(json, fields[:q], q) } if q
        end
      end
    end if [q, fields[:query].map { |f| send(f) }].flatten.any?
  end

  def filter_from_fields(json, fields)
    json.filter do
      json.bool do
        json.must do
          fields[:filter].each do |field|
            search = send(field)
            json.child! { filter_from_fields_child(json, field, search) } if search
          end
        end
      end
    end if fields[:filter].map { |f| send(f) }.any?
  end

  def terms_filter_from_field_mapping(json, field_mapping)
    json.filter do
      json.bool do
        json.must do
          field_mapping.each do |field, filter_value|
            json.child! { generate_terms(json, field, filter_value) } if filter_value
          end
        end
      end
    end if field_mapping.values.any?
  end

  def filter_from_fields_child(json, field, search)
    json.query { generate_match(json, field, search) }
  end

  def generate_query(json)
    query_from_fields(json, query_fields)
  end

  def generate_filter(json)
    filter_from_fields(json, query_fields)
  end

  def generate_date_range(json, field_name, range)
    valid_date_range?(range)
    terms = range.split(' TO ')
    json.child! do
      json.range do
        json.set! field_name do
          json.from terms[0]
          json.to terms[1]
        end
      end
    end
  end

  def valid_date_range?(range)
    match = /^(\d{4}(?:\-\d{2}\-\d{2})?) TO (\d{4}(?:\-\d{2}\-\d{2})?)$/.match(range)
    fail Exceptions::InvalidDateRangeFormat if match.nil?
    [match[1], match[2]].each { |date| /^\d{4}$/.match(date) || Date.parse(date) }
    true
  rescue
    raise Exceptions::InvalidDateRangeFormat
  end

  def generate_from_size_sort(json)
    json.from @offset
    json.size @size
  end

  def generate_aggregations(json)
    json.aggs do
      aggregation_terms.each do |k, v|
        json.set! k do
          json.terms do
            json.field v[:field]
            json.size v[:size] || 0
          end
        end
      end
    end
  end

  private

  def cleanup_invalid_bytes(obj, fields)
    fields.each do |f|
      obj[f] = obj[f].encode('UTF-8', 'UTF-8', invalid: :replace, undef: :replace, replace: '') if obj[f]
    end
  end
end
