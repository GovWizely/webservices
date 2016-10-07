module Envirotech
  class Consolidated
    include Searchable
    self.model_classes = [Envirotech::Solution,
                          Envirotech::Issue,
                          Envirotech::Regulation,
                          Envirotech::Provider,
                          Envirotech::AnalysisLink,
                          Envirotech::BackgroundLink,
                          Envirotech::ProviderSolution]
    self.fetch_all_sort_by = 'name_english.sort'
  end
end
