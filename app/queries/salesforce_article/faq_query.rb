module SalesforceArticle
  class FaqQuery < SalesforceArticle::Query
    MULTI_FIELDS = %i(question answer references summary)
  end
end
