module ScreeningList
  class Dpl
    include Indexable
    include ScreeningList::Mappable
    self.source = {
      full_name: 'Denied Persons List (DPL) - Bureau of Industry and Security',
      code:      'DPL',
    }
  end
end
