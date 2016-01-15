module Envirotech
  class RegulationData < Envirotech::BaseData
    ENDPOINT = 'https://admin.export.gov/admin/envirotech_regulations.json'

    COLUMN_HASH = {
      'id'              => :source_id,
      'name_chinese'    => :name_chinese,
      'name_english'    => :name_english,
      'name_french'     => :name_french,
      'name_portuguese' => :name_portuguese,
      'name_spanish'    => :name_spanish,
      'created_at'      => :source_created_at,
      'updated_at'      => :source_updated_at,
      'url'             => :url,
    }.freeze

    private

    def process_article_info(article)
      super(article).merge(issue_ids: [], solution_ids: [])
    end
  end
end
