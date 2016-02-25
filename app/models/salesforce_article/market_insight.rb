module SalesforceArticle
  class MarketInsight
    include Indexable
    include SalesforceArticle::Mappable
    self.source = {
      code: 'MARKET_INSIGHT',
    }
  end
end
