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
      if @relation_data.present?
        article[:issue_ids] = get_issue_ids(article)

        solution_ids = get_solution_ids(article)
        article[:solution_ids] = solution_ids if solution_ids.present?
      end
      sanitize_entry(article)
    end

    def process_relations(articles)
      issue_documents = Envirotech::ToolkitData.process_issue_relations(articles, :regulation_ids)
      solution_documents = Envirotech::ToolkitData.process_solution_relations(articles)
      Envirotech::Issue.update(issue_documents)
      Envirotech::Solution.update(solution_documents)
    end

    def get_issue_ids(article)
      @relation_data.select { |_, v| v.with_indifferent_access[:regulations].include?(article[:name_english]) }.keys.map(&:to_i)
    end

    def get_solution_ids(article)
      related_solutions = @relation_data.select do |_, v|
        v.with_indifferent_access[:regulations].include?(article[:name_english])
      end.map { |_, hash| hash.with_indifferent_access[:solutions] }.flatten
      solution_ids_names.select { |_, name_english| related_solutions.include?(name_english) }.map(&:first)
    end

    def solution_ids_names
      if !@solution_ids_names
        solution_documents = Envirotech::Consolidated.search_for(sources: 'solutions', size: 100)
        @solution_ids_names = solution_documents[:hits].map { |d|  [d[:_source][:source_id], d[:_source][:name_english]] }
      else
        @solution_ids_names
      end
    end

    def data
      @data ||= fetch_data
    end
  end
end
