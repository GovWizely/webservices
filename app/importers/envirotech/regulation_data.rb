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

    def initialize(resource = ENDPOINT)
      @resource = resource
    end

    def loaded_resource
      @loaded_resource ||= data.to_s
    end

    def import
      articles = data.map { |article_hash| process_article_info article_hash }
      process_relations(articles) if Envirotech::Relationships.relational_data.present?
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
      if Envirotech::Relationships.relational_data.present?
        article[:issue_ids] = Envirotech::Relationships.new.issues_for_regulation(article)

        solution_ids = Envirotech::Relationships.new.solutions_for_regulation(article)
        article[:solution_ids] = solution_ids if solution_ids.present?
      end
      sanitize_entry(article)
    end

    def process_relations(articles)
      issue_documents = Envirotech::Relationships.new.issues_with_relations(articles, :regulation_ids)
      solution_documents = Envirotech::Relationships.new.solutions_for_regulations(articles)
      Envirotech::Issue.update(issue_documents)
      Envirotech::Solution.update(solution_documents)
    end

    def data
      @data ||= fetch_data
    end
  end
end
