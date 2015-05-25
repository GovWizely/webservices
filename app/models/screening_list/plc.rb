module ScreeningList
  class Plc
    include Indexable
    include ScreeningList::Mappable
    self.source = {
      full_name: 'Palestinian Legislative Council List (PLC) - Treasury Department',
      code:      'PLC',
    }
  end
end
