module ScreeningList
  class Isa
    include Indexable
    include ScreeningList::Mappable
    self.source = {
      full_name: 'Non-SDN Iranian Sanctions Act List (NS-ISA) - Treasury Department',
      code:      'ISA',
    }
  end
end
