module ScreeningList
  class Base
    include Importable
    include VersionableResource
    include ScreeningList::TreasuryListImporter
    include ScreeningList::MakeNameVariants
    self.disabled = true
  end
end
