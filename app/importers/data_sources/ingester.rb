module DataSources
  class Ingester
    def initialize(klass, metadata, data)
      @klass = klass
      @metadata = metadata
      @data = data
    end

    private

    def insert_row(row)
      @klass.create(@metadata.transform(row))
    end
  end
end
