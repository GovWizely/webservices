module ScreeningList
  class Consolidated
    extend ::Consolidated
    self.query_class   = ScreeningList::Query
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
