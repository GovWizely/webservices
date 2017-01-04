require 'active_record'

module OrmAdapter
  class Elasticsearch < Base
    def column_names
      klass.attribute_set.map(&:name)
    end

    def get!(id)
      get(id)
    end

    def get(id)
      klass.search(query: { match: { _id: wrap_key(id) } }).first
    end

    def find_first(options = {})
      construct_relation(klass, options).first
    end

    def find_all(options = {})
      construct_relation(klass, options)
    end

    def create!(attributes = {})
      klass.create(attributes)
    end

    def destroy(object)
      object.delete && true
    end

    protected

    def construct_relation(klass, options)
      must = options.keys.map do |field|
        key = (field == :id) ? :_id : field
        { term: { key => options[field] } }
      end

      query = { query: { bool: { filter: must } } }
      klass.search(query)
    end
  end
end
