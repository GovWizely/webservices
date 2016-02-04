module SalesforceArticle
  class TradeAgreement
    include Indexable
    include SalesforceArticle::Mappable
    self.source = {
      code: 'TRADE_AGREEMENT',
    }
  end
end
