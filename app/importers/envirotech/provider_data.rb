module Envirotech
  class ProviderData
    include Importer
    ENDPOINT = 'https://admin.export.gov/admin/envirotech_providers.json'


    COLUMN_HASH = {
      'id' => :source_id,
      'name' => :name_english,
      'created_at' => :source_created_at,
      'updated_at' => :source_updated_at,
    }.freeze

    def initialize(resource = ENDPOINT)
      @resource = resource
    end

    def import
      data = fetch_data
      articles = data.map { |article_hash| process_article_info article_hash }
      model_class.index articles
    end

    private

    def fetch_data
      Envirotech::Login.headless_login
      result = []
      result.concat(current_page_data) until current_page_empty?
      result
    end

    def current_page_empty?
      @page ||= 1
      @page_data = JSON.parse(Envirotech::Login.mechanize_agent.get(@resource + "?page=#{@page}").body)
      @page += 1
      @page_data.blank?
    end

    def current_page_data
      @page_data
    end

    def process_article_info(article_hash)
      article = remap_keys COLUMN_HASH, article_hash

      %i(source_created_at source_updated_at).each do |field|
        article[field] &&= Date.parse(article[field]).iso8601 rescue nil
      end

      article[:source] = model_class.source[:code]

      article[:id] = Utils.generate_id(article, %i(source_id name_english source))
      sanitize_entry(article)
    end
  end
end
