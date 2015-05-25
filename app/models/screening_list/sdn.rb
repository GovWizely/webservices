module ScreeningList
  class Sdn
    include Indexable
    include ScreeningList::Mappable
    self.source = {
      full_name: 'Specially Designated Nationals (SDN) - Treasury Department',
      code:      'SDN',
    }
  end
end
