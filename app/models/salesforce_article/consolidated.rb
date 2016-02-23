module SalesforceArticle
  class Consolidated
    include Searchable
    self.model_classes = [
      SalesforceArticle::CountryCommercial,
      SalesforceArticle::Generic,
      SalesforceArticle::MarketInsight,
      SalesforceArticle::StateReport,
      SalesforceArticle::TopMarkets,
    ]
  end
end
