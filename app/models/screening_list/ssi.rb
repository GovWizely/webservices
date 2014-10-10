module ScreeningList
  class Ssi
    extend ::Indexable
    extend ::Model::CanDeleteOldDocuments
    include ScreeningList::Mappable
    self.source = {
      full_name: 'Sectoral Sanctions Identifications List (SSI) - Treasury Department',
      code:      'SSI',
    }
  end
end
