module SalesforceArticle
  class Consolidated
    include Searchable
    self.model_classes = [
      SalesforceArticle::CountryCommercial,
      SalesforceArticle::MarketInsight,
    ]
  end
end
