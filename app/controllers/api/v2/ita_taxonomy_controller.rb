class Api::V2::ItaTaxonomyController < Api::V2Controller
  include Searchable
  include TaxonomyMethods
  search_by :q

  def query_expansion
    @query_expansion = params.permit(search_params).require(:q)

    @taxonomy_parser = TaxonomyParser.new(Rails.configuration.frozen_protege_source)
    @taxonomy_parser.concepts = YAML.load_file(Rails.configuration.frozen_taxonomy_concepts)

    @results = { query_expansion: build_json }
  end

  rescue_from(ActionController::ParameterMissing) do |e|
    render json:   { error: e.message },
           status: :bad_request
  end

  private

  def build_json
    relevant_labels = parse_query_expansion
    query_response = add_geo_fields(relevant_labels)

    @query_expansion = strip_punctuation(@query_expansion)

    query_response.each { |_key, array| build_queries(array) }

    query_response
  end

  def build_queries(array)
    array.map! do |label|
      { label.to_sym => "#{@query_expansion} #{label}".strip.gsub(/\s+/, ' ') }
    end
  end

  def strip_punctuation(string)
    string.downcase.gsub(/[^a-z0-9\s]/i, '')
  end

  def parse_query_expansion
    labels = get_country_labels
    parsed_values = []
    labels.each do |label|
      if @query_expansion.include?(label.downcase)
        parsed_values.push(label)
        @query_expansion.slice!(label.downcase)
      end
    end
    parsed_values
  end

  def get_country_labels
    @taxonomy_parser.get_concepts_by_concept_group('Countries').map { |term| term[:label] }
  end
end
