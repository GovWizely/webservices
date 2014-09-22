class Query
  DEFAULT_SIZE = 10.freeze
  MAX_SIZE = 100.freeze
  attr_reader :offset, :size, :sort, :q

  def self.query_fields(fields)
    fields.each do |sym|
      attr_reader sym
    end
    class_variable_set('@@fields', fields)
  end

  def initialize(options)
    options.reverse_merge!(size: DEFAULT_SIZE)
    @offset = options[:offset].to_i
    @size = [options[:size].to_i, MAX_SIZE].min
    fields = self.class.class_variable_get('@@fields') rescue {query:[], filter:[]}
    fields[:query].each do |sym|
      instance_variable_set("@#{sym}", options[sym])
    end
    fields[:filter].each do |sym|
      instance_variable_set("@#{sym}", options[sym])
    end
    instance_variable_set("@q", options[:q])
    instance_variable_set("@sort", f[:sort].try(:join,',')) unless q
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
    fields[:searchable] ||= []
    json.query do
      json.bool do
        json.must do
          fields[:searchable].each do |field|
            search = send(field)
            json.child! { generate_match(json, field, search) } if search
          end
          json.child! { generate_multi_match(json, fields[:q], q) } if q
        end
      end
    end if [q, fields[:searchable].map { |f| send(f) }].flatten.any?
  end

  def filter_from_fields(json, fields)
    json.filter do
      json.bool do
        json.must do
          fields[:searchable].each do |field|
            search = send (field)
            json.child! { json.query { json.match { json.set! field, search } } } if search
          end
        end
      end
    end if fields[:searchable].map { |f| send(f) }.any?
  end
  def self.setup_query(fields)
    fields.reverse_merge!(query: [], filter: [], sort: [])
    fields[:query ].each { |f| attr_reader f }
    fields[:filter].each { |f| attr_reader f }
    class_variable_set('@@fields', fields)
  end
  def f
    self.class.class_variable_get('@@fields') rescue {}
  end
  def my_query_fields
    {searchable: f[:query], q: f[:q]}
  end
  def my_filter_fields
    {searchable: f[:filter]}
  end
  def my_q_fields
    f[:q]
  end
end
