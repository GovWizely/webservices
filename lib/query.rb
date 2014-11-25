class Query
  DEFAULT_SIZE = 10.freeze
  MAX_SIZE = 100.freeze
  attr_reader :offset, :size, :sort, :q

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
    options.reverse_merge!(size: DEFAULT_SIZE)

    cleanup_invalid_bytes(options, [:q])

    @offset = options[:offset].to_i
    @size   = [options[:size].to_i, MAX_SIZE].min
    @q      = options[:q]
    initialize_search_fields(options)
  end

  def initialize_search_fields(options)
    if query_fields
      query_fields[:query] .each { |f| instance_variable_set("@#{f}", options[f]) }
      query_fields[:filter].each { |f| instance_variable_set("@#{f}", options[f]) }
      instance_variable_set('@sort', query_fields[:sort].try(:join, ',')) unless q
    end
  end

  def generate_search_body
    Jbuilder.encode do |json|
      generate_query(json)
      generate_filter(json)
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
            json.child! { json.query { json.match { json.set! field, search } } } if search
          end
        end
      end
    end if fields[:filter].map { |f| send(f) }.any?
  end

  def generate_query(json)
    query_from_fields(json, query_fields)
  end

  def generate_filter(json)
    filter_from_fields(json, query_fields)
  end

  private

  def cleanup_invalid_bytes(obj, fields)
    fields.each do | f |
      obj[f] = obj[f].encode('UTF-8', 'UTF-8', invalid: :replace, undef: :replace, replace: '') if obj[f]
    end
  end
end
