module Envirotech
  class ProviderSolutionData < Envirotech::BaseData
    include Importable
    include ::VersionableResource

    ENDPOINT = 'https://admin.export.gov/admin/envirotech_provider_solutions.json'

    COLUMN_HASH = {
      'id'                     => :source_id,
      'url'                    => :url,
      'envirotech_provider_id' => :provider_id,
      'envirotech_solution_id' => :solution_ids,
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

      article[:source] = model_class.source[:code]

      article[:id] = Utils.generate_id(article, %i(source_id source))
      sanitize_entry(article)
    end

    def data
      @data ||= fetch_data
    end
  end
end
