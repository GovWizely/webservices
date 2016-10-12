module Envirotech
  class BackgroundLinkData < Envirotech::BaseData
    ENDPOINT = Rails.root.join('data/envirotech/regulatory_background_links.json').to_s

    COLUMN_HASH = ENVIROTECH_ISSUE_HASH
  end
end
