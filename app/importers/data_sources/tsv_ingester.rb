module DataSources
  class TSVIngester < SVIngester
    def initialize(klass, metadata, data)
      super(klass, metadata, data, "\t")
    end
  end
end
