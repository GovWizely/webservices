module SalesforceArticle
  class Generic
    include Indexable
    include SalesforceArticle::Mappable
    self.source = {
      code: 'GENERIC',
    }
  end
end
