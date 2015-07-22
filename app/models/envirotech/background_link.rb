module Envirotech
  class BackgroundLink
    include Indexable
    include Envirotech::Mappable
    self.source = {
      code: 'BACKGROUND_LINKS',
    }
  end
end
