module Envirotech
  class Consolidated
    include Searchable
    self.model_classes = [Envirotech::Solution,
                          Envirotech::Issue,
                          Envirotech::Regulation]
  end
end
