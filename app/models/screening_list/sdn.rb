module ScreeningList
  class Sdn
    extend ::Indexable
    include Mappable
    self.source = {
      full_name: 'Special Designated Nationals (SDN) - Treasury Department',
      code:      'SDN',
    }
  end
end
