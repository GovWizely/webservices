module Envirotech
  class Solution
    include Indexable
    include Envirotech::Mappable
    self.source = {
      code: 'SOLUTIONS',
    }
  end
end
