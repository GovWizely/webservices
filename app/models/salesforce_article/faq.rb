module SalesforceArticle
  class Faq
    include Indexable
    include SalesforceArticle::Mappable

    self.source = {
      full_name: 'ITA',
      code:      'SFFAQ',
    }
  end
end
