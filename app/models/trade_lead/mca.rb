module TradeLead
  class Mca
    extend ::Indexable
    include TradeLead::Mappable
    self.source = {
      code: 'MCA',
    }
  end
end
