module ScreeningList
  class Uvl
    extend ::Indexable
    include Mappable
    self.source = {
      full_name: 'Unverified List - Bureau of Industry and Security',
      code:      'UVL',
    }
  end
end
