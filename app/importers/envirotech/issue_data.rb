module Envirotech
  class IssueData < Envirotech::BaseData
    include Importable
    include ::VersionableResource

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

    def initialize(resource = ENDPOINT)
      @resource = resource
    end

    def loaded_resource
      @loaded_resource ||= data.to_s
    end

    def import
      articles = data.map { |article_hash| process_article_info article_hash }
      model_class.index articles
    end

    private

    def process_article_info(article_hash)
      article = remap_keys COLUMN_HASH, article_hash

      %i(source_created_at source_updated_at).each do |field|
        article[field] &&= Date.parse(article[field]).iso8601 rescue nil
      end

      article[:solution_ids] = article[:regulation_ids] = []

      article[:source] = model_class.source[:code]

      article[:id] = article[:source_id]
      sanitize_entry(article)
    end

    def data
      @data ||= fetch_data
    end
  end
end
