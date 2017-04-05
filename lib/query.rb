class Query
  include ActiveModel::Validations

  class InvalidParamsException < Exception
    attr_accessor :errors
  end

  DEFAULT_SIZE = 10
  MAX_SIZE = 100
  UNLIMITED = 2**30
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
    class_variable_get('@@fields')
  rescue
    nil
  end

  def query_fields
    self.class.query_fields
  end

  def self.setup_query(fields)
    fields.reverse_merge!(query: [], filter: [], sort: [], raw_enabled: [])
    fields[:query].each { |f| attr_reader f }
    fields[:filter].each { |f| attr_reader f }
    self.query_fields = fields
  end

  def initialize(options = {})
    options.delete_if { |_k, v| v == '' }
    options.reverse_merge!(size: DEFAULT_SIZE)

    cleanup_invalid_bytes(options, [:q, :name])

    @offset = options[:offset].to_i
    @size = [options[:size].to_i, MAX_SIZE].min
    @q = options[:q]

    @sort = options[:sort] ? parse_sort_parameter(options[:sort]) : []
    initialize_search_fields(options)

    unless valid?
      e = InvalidParamsException.new
      e.errors = errors.to_a
      raise e
    end
  end

  def parse_sort_parameter(value)
    array = split_to_array(value.strip)
    array.map! do |value|
      if value.include?(':')
        { maybe_raw(value.split(':')[0].strip) => value.split(':')[1].strip }
      else
        maybe_raw(value.strip)
      end
    end
  end

  def maybe_raw(field)
    query_fields[:raw_enabled].include?(field.to_sym) ? field + '.raw' : field
  end

  def initialize_search_fields(options)
    if query_fields
      query_fields[:query].each { |f| instance_variable_set("@#{f}", options[f]) }
      query_fields[:filter].each { |f| instance_variable_set("@#{f}", options[f]) }
      if @sort.empty? && @q.nil? && query_fields[:sort].present?
        @sort = query_fields[:sort]
      end
    end
  end

  def generate_search_body
    Jbuilder.encode do |json|
      generate_query_and_filter(json)
      generate_aggregations(json)
    end
  end

  def generate_multi_match(json, fields, query, operator = :and)
    json.multi_match do
      json.fields fields
      json.operator operator
      json.query query
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
    field_values = fields[:query].map { |f| send(f) }
    json.query do
      json.bool do
        generate_should_clauses(fields, json)
        yield if block_given?
      end
    end if [@q, field_values].flatten.any? || block_given?
  end

  def generate_should_clauses(fields, json)
    if @q
      json.minimum_should_match 1
      json.set! :should do
        multi_match_semantic_query(fields, json)
      end
    end
  end

  def multi_match_semantic_query(fields, json)
    json.child! { generate_multi_match(json, fields[:q], @q) }
    json.child! { generate_semantic_query(json, fields[:q]) } if @semantic_query && @semantic_query.query != @q
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

  def generate_query_and_filter(json)
    query_from_fields(json, query_fields) do
      generate_filter(json)
    end
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
    raise Exceptions::InvalidDateRangeFormat if match.nil?
    [match[1], match[2]].each { |date| /^\d{4}$/.match(date) || Date.parse(date) }
    true
  rescue
    raise Exceptions::InvalidDateRangeFormat
  end

  def generate_aggregations(json)
    json.aggs do
      aggregation_terms.each do |k, v|
        json.set! k do
          json.terms do
            json.field v[:field]
            json.size v[:size] || UNLIMITED
          end
        end
      end
    end
  end

  def set_geo_instance_variables(options)
    @countries = split_to_array(options[:countries].upcase) if options[:countries].present?
    @trade_regions = split_to_array(options[:trade_regions]) if options[:trade_regions].present?
    @world_regions = split_to_array(options[:world_regions]) if options[:world_regions].present?
  end

  def split_to_array(value)
    value.split(',').map(&:strip)
  end

  def generate_geo_filters(json, country_field)
    json.child! { json.terms { json.set! country_field, @countries } } if @countries
    json.child! { json.terms { json.trade_regions @trade_regions } } if @trade_regions
    json.child! { json.terms { json.world_regions @world_regions } } if @world_regions
  end

  private

  def cleanup_invalid_bytes(obj, fields)
    fields.each do |f|
      obj[f] = obj[f].encode('UTF-8', 'UTF-8', invalid: :replace, undef: :replace, replace: '') if obj[f]
    end
  end
end
