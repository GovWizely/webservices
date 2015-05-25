module TradeLead
  class Fbopen
    include Indexable
    include TradeLead::Mappable

    self.source = {
      code: 'FBO',
    }

    def self.importer_class
      TradeLead::FbopenImporter::FullData
    end
  end
end
