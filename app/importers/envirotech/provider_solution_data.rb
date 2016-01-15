module Envirotech
  class ProviderSolutionData < Envirotech::BaseData
    ENDPOINT = 'https://admin.export.gov/admin/envirotech_provider_solutions.json'

    COLUMN_HASH = {
      'id'                     => :source_id,
      'url'                    => :url,
      'envirotech_provider_id' => :provider_id,
      'envirotech_solution_id' => :solution_id,
    }.freeze

    private

    def process_article_info(article)
      article[:source] = model_class.source[:code]

      article[:id] = article[:source_id]

      article[:provider_name] = fetch_name('provider', article[:provider_id])
      article[:solution_name] = fetch_name('solution', article[:solution_id])
      article
    end

    def fetch_name(type, id)
      index = "Envirotech::#{type.capitalize}".constantize.index_name
      ES.client.get(index: index, id: id)['_source']['name_english']
    end
  end
end
