module TradeLead
  class Fbopen
    extend ::Indexable
    include TradeLead::Mappable

    self.source = {
      code: 'FBO',
    }
  end
end
