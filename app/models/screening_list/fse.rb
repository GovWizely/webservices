module ScreeningList
  class Fse
    extend ::Indexable
    extend ::Model::CanDeleteOldDocuments
    include ScreeningList::Mappable
    self.source = {
      full_name: 'Foreign Sanctions Evaders (FSE) - Treasury Department',
      code:      'FSE',
    }
  end
end
