class Query
  DEFAULT_SIZE = 10.freeze
  MAX_SIZE = 100.freeze
  attr_reader :offset, :size, :sort

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
    fields = self.class.class_variable_get('@@fields') rescue []
    fields.each do |sym|
      instance_variable_set("@#{sym}", options[sym])
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
end
