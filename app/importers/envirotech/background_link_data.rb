module Envirotech
  class BackgroundLinkData < Envirotech::BaseData
    ENDPOINT = 'https://admin.export.gov/admin/envirotech_regulatory_background_links.json'

    COLUMN_HASH = ENVIROTECH_ISSUE_HASH
  end
end
