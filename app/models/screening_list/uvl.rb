module ScreeningList
  class Uvl
    extend ::Indexable
    extend ::Model::CanDeleteOldDocuments
    include ScreeningList::Mappable
    self.source = {
      full_name: 'Unverified List - Bureau of Industry and Security',
      code:      'UVL',
    }
  end
end
