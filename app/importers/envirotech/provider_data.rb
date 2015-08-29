module Envirotech
  class ProviderData < Envirotech::BaseData
    include Importable
    include ::VersionableResource

    ENDPOINT = 'https://admin.export.gov/admin/envirotech_providers.json'

    COLUMN_HASH = {
      'id'         => :source_id,
      'name'       => :name_english,
      'created_at' => :source_created_at,
      'updated_at' => :source_updated_at,
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

      article[:source] = model_class.source[:code]

      article[:id] = Utils.generate_id(article, %i(source_id source))
      sanitize_entry(article)
    end

    def data
      @data ||= fetch_data
    end
  end
end
