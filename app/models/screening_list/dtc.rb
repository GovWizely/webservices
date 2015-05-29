module ScreeningList
  class Dtc
    include Indexable
    include ScreeningList::Mappable
    self.source = {
      full_name: 'ITAR Debarred (DTC) - State Department',
      code:      'DTC',
    }
  end
end
