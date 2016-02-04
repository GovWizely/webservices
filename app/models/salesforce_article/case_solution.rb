module SalesforceArticle
  class CaseSolution
    include Indexable
    include SalesforceArticle::Mappable
    self.source = {
      code: 'CASE_SOLUTION',
    }
  end
end
