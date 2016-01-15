module ScreeningList
  class BaseData
    include Importable
    include VersionableResource
    include ScreeningList::TreasuryListImporter
    include ScreeningList::MakeNameVariants
  end
end
