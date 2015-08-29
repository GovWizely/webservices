module Envirotech
  class SolutionData < Envirotech::BaseData
    include Importable
    ENDPOINT = 'https://admin.export.gov/admin/envirotech_solutions.json'
    include ::VersionableResource

    COLUMN_HASH = {
      'id'              => :source_id,
      'name_chinese'    => :name_chinese,
      'name_english'    => :name_english,
      'name_french'     => :name_french,
      'name_portuguese' => :name_portuguese,
      'name_spanish'    => :name_spanish,
      'created_at'      => :source_created_at,
      'updated_at'      => :source_updated_at,
    }.freeze

    def initialize(resource = ENDPOINT, relation_data: nil)
      @resource = resource
      @relation_data = relation_data
    end

    def loaded_resource
      @loaded_resource ||= data.to_s
    end

    def import
      articles = data.map { |article_hash| process_article_info article_hash }
      process_relations(articles)
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
      article[:issue_ids] = get_issue_ids(article) if @relation_data.present?

      sanitize_entry(article)
    end

    def process_relations(articles)
      issue_documents = Envirotech::ToolkitData.process_issue_relations(articles, :solution_ids)
      Envirotech::Issue.update(issue_documents)
    end

    def get_issue_ids(article)
      @relation_data.select { |_, v| v.with_indifferent_access[:solutions].include?(article[:name_english]) }.keys.map(&:to_i)
    end

    def data
      @data ||= fetch_data
    end
  end
end
