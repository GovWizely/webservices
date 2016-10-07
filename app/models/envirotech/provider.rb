module Envirotech
  class Provider
    include Indexable
    include Envirotech::Mappable
    self.source = {
      code: 'PROVIDERS',
    }
  end
end
