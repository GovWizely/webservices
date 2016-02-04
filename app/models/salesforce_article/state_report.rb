module SalesforceArticle
  class StateReport
    include Indexable
    include SalesforceArticle::Mappable
    self.source = {
      code: 'STATE_REPORT',
    }
  end
end
