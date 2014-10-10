module ScreeningList
  class Isn
    extend ::Indexable
    extend ::Model::CanDeleteOldDocuments
    include ScreeningList::Mappable
    self.source = {
      full_name: 'Nonproliferation Sanctions (ISN) - State Department',
      code:      'ISN',
    }
  end
end
