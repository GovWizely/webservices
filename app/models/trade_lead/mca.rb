module TradeLead
  class Mca
    include Indexable
    include TradeLead::Mappable
    self.source = {
      code: 'MCA',
    }
  end
end
