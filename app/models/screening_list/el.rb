module ScreeningList
  class El
    extend ::Indexable
    include ScreeningList::Mappable
    self.source = {
      full_name: 'Entity List (EL) - Bureau of Industry and Security',
      code:      'EL',
    }
  end
end
