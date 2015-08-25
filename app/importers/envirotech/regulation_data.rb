module Envirotech
  class RegulationData < Envirotech::BaseData
    include Importable
    include ::VersionableResource

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

    def initialize(resource = ENDPOINT, relation_data: nil)
      @resource = resource
      @relation_data = relation_data
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
      article[:issue_id] = get_issues_ids(article) if @relation_data.present?

      sanitize_entry(article)
    end

    def get_issues_ids(article)
      @relation_data.select { |_, v| v.with_indifferent_access[:regulations].include?(article[:name_english]) }.keys.map(&:to_i)
    end
  end
end
