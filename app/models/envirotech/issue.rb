module Envirotech
  class Issue
    include Indexable
    include Envirotech::Mappable
    self.source = {
      code: 'ISSUES',
    }
  end
end
