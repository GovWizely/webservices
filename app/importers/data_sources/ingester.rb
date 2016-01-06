module DataSources
  class Ingester
    BULK_GROUP_SIZE = 1000

    def initialize(klass, metadata, data)
      @klass = klass
      @metadata = metadata
      @data = data
    end

    private

    def insert(rows)
      rows.in_groups_of(BULK_GROUP_SIZE, false) do |group|
        ES.client.bulk(index: @klass.index_name, type: @klass.document_type, body: bulkify(group))
      end
    end

    def bulkify(records)
      records.reduce([]) do |bulk_array, record|
        bulk_array << { index: {} }
        bulk_array << @metadata.transform(record)
      end
    end

  end
end
