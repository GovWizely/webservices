module SalesforceArticle
  class Consolidated
    include Searchable
    self.model_classes = [
      SalesforceArticle::CaseSolution,
      SalesforceArticle::CountryCommercial,
      SalesforceArticle::Generic,
      SalesforceArticle::MarketInsight,
      SalesforceArticle::StateReport,
      SalesforceArticle::TopMarkets,
      SalesforceArticle::TradeAgreement,
    ]
  end
end
