module ScreeningList
  class Dtc
    extend ::Indexable
    extend ::Model::CanDeleteOldDocuments
    include ScreeningList::Mappable
    self.source = {
      full_name: 'ITAR Debarred (DTC) - State Department',
      code:      'DTC',
    }
  end
end
