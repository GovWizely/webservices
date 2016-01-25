module Envirotech
  include CanImportAllSources

  ENVIROTECH_ISSUE_HASH = {
    'id'                  => :source_id,
    'name_chinese'        => :name_chinese,
    'name_english'        => :name_english,
    'name_french'         => :name_french,
    'name_portuguese'     => :name_portuguese,
    'name_spanish'        => :name_spanish,
    'created_at'          => :source_created_at,
    'updated_at'          => :source_updated_at,
    'url'                 => :url,
    'envirotech_issue_id' => :issue_ids,
  }.freeze

  def self.import_all_sources
    Envirotech::ImportWorker.perform_async
  end

  def self.import_sequentially
    Envirotech::IssueData.new.import
    Envirotech::SolutionData.new.import
    Envirotech::RegulationData.new.import
    Envirotech::ProviderData.new.import
    Envirotech::AnalysisLinkData.new.import
    Envirotech::BackgroundLinkData.new.import
    Envirotech::ProviderSolutionData.new.import
    Envirotech::RelationalData.new.import
    true
  end
end
