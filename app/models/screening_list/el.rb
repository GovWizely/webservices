module ScreeningList
  class El
    extend ::Indexable
    extend ::Model::CanDeleteOldDocuments
    include ScreeningList::Mappable
    self.source = {
      full_name: 'Entity List (EL) - Bureau of Industry and Security',
      code:      'EL',
    }
  end
end
