module DataSources
  class CSVIngester < SVIngester
    def initialize(klass, metadata, data)
      super(klass, metadata, data, ',')
    end
  end
end
