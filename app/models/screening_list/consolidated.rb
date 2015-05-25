module ScreeningList
  class Consolidated
    include Searchable
    self.model_classes = [ScreeningList::Dpl,
                          ScreeningList::Dtc,
                          ScreeningList::El,
                          ScreeningList::Fse,
                          ScreeningList::Isa,
                          ScreeningList::Isn,
                          ScreeningList::Part561,
                          ScreeningList::Plc,
                          ScreeningList::Sdn,
                          ScreeningList::Ssi,
                          ScreeningList::Uvl]
  end
end
