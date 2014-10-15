module ScreeningList
  class Ssi
    extend ::Indexable
    include Mappable
    self.source = {
      full_name: 'Sectoral Sanctions Identifications List (SSI) - Treasury Department',
      code:      'SSI',
    }
  end
end
