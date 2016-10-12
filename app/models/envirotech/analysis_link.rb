module Envirotech
  class AnalysisLink
    include Indexable
    include Envirotech::Mappable
    self.source = {
      code: 'ANALYSIS_LINKS',
    }
  end
end
