module TradeLead
  class Uk
    extend ::Indexable
    include TradeLead::Mappable

    self.source = {
      code: 'UK',
    }
  end
end
