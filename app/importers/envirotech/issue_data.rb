module Envirotech
  class IssueData < Envirotech::BaseData
    ENDPOINT = 'https://admin.export.gov/admin/envirotech_issues.json'

    COLUMN_HASH = {
      'id'                  => :source_id,
      'name_chinese'        => :name_chinese,
      'name_english'        => :name_english,
      'name_french'         => :name_french,
      'name_portuguese'     => :name_portuguese,
      'name_spanish'        => :name_spanish,
      'created_at'          => :source_created_at,
      'updated_at'          => :source_updated_at,
      'abstract_chinese'    => :abstract_chinese,
      'abstract_english'    => :abstract_english,
      'abstract_french'     => :abstract_french,
      'abstract_portuguese' => :abstract_portuguese,
      'abstract_spanish'    => :abstract_spanish,
    }.freeze

    private

    def process_article_info(article)
      %i(source_created_at source_updated_at).each do |field|
        article[field] &&= Date.parse(article[field]).iso8601 rescue nil
      end

      article[:solution_ids] = article[:regulation_ids] = []

      article[:source] = model_class.source[:code]

      article[:id] = article[:source_id]
      article
    end
  end
end
