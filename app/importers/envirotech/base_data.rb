require 'uri'

module Envirotech
  class BaseData
    include Importable
    include ::VersionableResource
    self.disabled = true

    def initialize(resource = self.class::ENDPOINT)
      @resource = resource
    end

    def loaded_resource
      @loaded_resource ||= data.to_s
    end

    def import
      articles = data.map do |article_hash|
        sanitize_entry(process_article_info(remap_keys(self.class::COLUMN_HASH, article_hash)))
      end
      model_class.index articles
    end

    private

    def process_article_info(article)
      %i(source_created_at source_updated_at).each do |field|
        article[field] &&= Date.parse(article[field]).iso8601 rescue nil
      end
      article[:source] = model_class.source[:code]
      article[:id] = article[:source_id]
      article
    end

    def fetch_data
      @resource =~ URI.regexp ? from_web : from_file
    end

    def from_web
      Envirotech::Login.headless_login
      page = 1
      result = []
      loop do
        page_data = JSON.parse(Envirotech::Login.mechanize_agent.get(@resource + "?page=#{page}").body)
        break if page_data.blank?
        result.concat(page_data)
        page += 1
      end
      result
    end

    def from_file
      JSON.parse(File.open(@resource).read)
    end

    def data
      @data ||= fetch_data
    end
  end
end
