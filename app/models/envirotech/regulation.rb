module Envirotech
  class Regulation
    include Indexable
    include Envirotech::Mappable
    self.source = {
      code: 'REGULATIONS',
    }
  end
end
