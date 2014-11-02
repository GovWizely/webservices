module ScreeningList
  class Sdn
    extend ::Indexable
    include ScreeningList::Mappable
    self.source = {
      full_name: 'Specially Designated Nationals (SDN) - Treasury Department',
      code:      'SDN',
    }
  end
end
