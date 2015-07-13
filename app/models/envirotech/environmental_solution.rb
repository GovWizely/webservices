module Envirotech
  class EnvironmentalSolution
    include Indexable
    include Envirotech::Mappable
    self.source = {
      code: 'EnvironmentalSolution',
    }
  end
end
