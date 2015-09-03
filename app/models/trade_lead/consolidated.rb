module TradeLead
  class Consolidated
    include Searchable
    self.model_classes = [TradeLead::Canada,
                          TradeLead::Fbopen,
                          TradeLead::State,
                          TradeLead::Uk,
                          TradeLead::Mca]
  end
end
