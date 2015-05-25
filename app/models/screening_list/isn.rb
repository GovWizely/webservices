module ScreeningList
  class Isn
    include Indexable
    include ScreeningList::Mappable
    self.source = {
      full_name: 'Nonproliferation Sanctions (ISN) - State Department',
      code:      'ISN',
    }
  end
end
