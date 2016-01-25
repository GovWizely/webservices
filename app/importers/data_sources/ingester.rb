module DataSources
  class Ingester
    BULK_GROUP_SIZE = 1000

    def initialize(klass, metadata, data)
      @klass = klass
      @metadata = metadata
      @data = data
      @unique_fields = @metadata.unique_fields.keys
    end

    private

    def insert(rows)
      rows.in_groups_of(BULK_GROUP_SIZE, false) do |group|
        ES.client.bulk(index: @klass.index_name, type: @klass.document_type, body: bulkify(group))
      end
    end

    def bulkify(records)
      records.reduce([]) do |bulk_array, record|
        bulk_array << { index: unique_record_id(record) }
        bulk_array << @metadata.transform(record)
      end
    end

    def unique_record_id(record)
      @unique_fields.present? ? { _id: Utils.generate_id(record, @unique_fields) } : {}
    end
  end
end
