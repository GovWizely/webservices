module SalesforceArticle
  class CountryCommercial
    include Indexable
    include SalesforceArticle::Mappable
    self.source = {
      code: 'COUNTRY_COMMERCIAL',
    }
  end
end
