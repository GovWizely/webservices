module EnvironmentalToolkit
  class EnvironmentalSolution
    include Indexable
    include EnvironmentalToolkit::Mappable
    self.source = {
      code: 'EnvironmentalSolution',
    }
  end
end
