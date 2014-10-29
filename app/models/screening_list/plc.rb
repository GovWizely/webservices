module ScreeningList
  class Plc
    extend ::Indexable
    include ScreeningList::Mappable
    self.source = {
      full_name: 'Palestinian Legislative Council List (PLC) - Treasury Department',
      code:      'PLC',
    }
  end
end
