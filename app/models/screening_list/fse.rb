module ScreeningList
  class Fse
    include Indexable
    include ScreeningList::Mappable
    self.source = {
      full_name: 'Foreign Sanctions Evaders (FSE) - Treasury Department',
      code:      'FSE',
    }
  end
end
