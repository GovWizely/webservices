module EnvironmentalToolkit
  class Consolidated
    include Searchable
    self.model_classes = [EnvironmentalToolkit::EnvironmentalSolution]
  end
end
