module Envirotech
  class AnalysisLinkData < Envirotech::BaseData
    ENDPOINT = Rails.root.join('data/envirotech/regulatory_analysis_links.json').to_s

    COLUMN_HASH = ENVIROTECH_ISSUE_HASH
  end
end
