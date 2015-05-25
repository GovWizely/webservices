module ScreeningList
  class Ssi
    include Indexable
    include ScreeningList::Mappable
    self.source = {
      full_name: 'Sectoral Sanctions Identifications List (SSI) - Treasury Department',
      code:      'SSI',
    }
  end
end
