module ScreeningList
  class Dtc
    extend ::Indexable
    include Mappable
    self.source = {
      full_name: 'ITAR Debarred (DTC) - State Department',
      code:      'DTC',
    }
  end
end
