module Envirotech
  class ProviderSolution
    include Indexable
    include Envirotech::Mappable
    self.source = {
      code: 'PROVIDER_SOLUTIONS',
    }
  end
end
