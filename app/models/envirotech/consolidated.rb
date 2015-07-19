module Envirotech
  class Consolidated
    include Searchable
    self.model_classes = [Envirotech::Solution]
  end
end
