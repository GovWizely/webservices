module ScreeningList
  class Sdn
    extend ::Indexable
    extend ::Model::CanDeleteOldDocuments
    include ScreeningList::Mappable
    self.source = {
      full_name: 'Special Designated Nationals (SDN) - Treasury Department',
      code:      'SDN',
    }
  end
end
