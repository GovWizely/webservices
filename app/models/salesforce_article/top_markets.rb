module SalesforceArticle
  class TopMarkets
    include Indexable
    include SalesforceArticle::Mappable
    self.source = {
      code: 'TOP_MARKETS',
    }
  end
end
