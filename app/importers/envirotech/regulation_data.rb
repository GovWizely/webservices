module Envirotech
  class RegulationData < Envirotech::BaseData
    include Importable
    ENDPOINT = 'https://admin.export.gov/admin/envirotech_regulations.json'

    RELATION_DATA = "#{Rails.root}/data/envirotech/issue_solution_regulation.json"

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

    def initialize(relation_data = RELATION_DATA, resource = ENDPOINT)
      @resource = resource
      if relation_data == RELATION_DATA
        @relation_data = JSON.parse(open(relation_data).read)
      else
        @relation_data = relation_data
      end
    end

    def import
      data = fetch_data
      articles = data.map { |article_hash| process_article_info article_hash }
      model_class.index articles
    end

    private

    def process_article_info(article_hash)
      article = remap_keys COLUMN_HASH, article_hash

      %i(source_created_at source_updated_at).each do |field|
        article[field] &&= Date.parse(article[field]).iso8601 rescue nil
      end

      article[:source] = model_class.source[:code]

      article[:id] = Utils.generate_id(article, %i(source_id source))
      article[:issue_id] = @relation_data.select{ |_,v| v.with_indifferent_access[:regulations].include?(article[:name_english]) }.keys.map(&:to_i)

      sanitize_entry(article)
    end
  end
end
