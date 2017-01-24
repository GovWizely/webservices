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

    protected

    def process_article_info(article)
      %i(source_created_at source_updated_at).each do |field|
        begin
          article[field] &&= Date.parse(article[field]).iso8601
        rescue
          nil
        end
      end
      article[:source] = model_class.source[:code]
      article[:id] = article[:source_id]
      article
    end

    private

    def fetch_data
      @resource = JSON.parse(File.open(@resource).read)
    end

    def data
      @data ||= fetch_data
    end
  end
end
