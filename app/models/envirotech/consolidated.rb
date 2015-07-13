module Envirotech
  class Consolidated
    include Searchable
    self.model_classes = [Envirotech::EnvironmentalSolution]
  end
end
