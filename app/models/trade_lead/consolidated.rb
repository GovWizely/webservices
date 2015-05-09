module TradeLead
  class Consolidated
    extend ::Consolidated
    self.query_class   = TradeLead::Query
    self.model_classes = [TradeLead::Australia,
                          TradeLead::Canada,
                          TradeLead::Fbopen,
                          TradeLead::State,
                          TradeLead::Uk]
                          #TradeLead::Mca]
  end
end
