class Api::V2::ItaTaxonomyController < Api::V2Controller
  include Searchable
  search_by :q, :types, :labels

  def query_expansion
    @query_expansion = params.permit(search_params).require(:q).downcase

    @results = { query_expansion: build_json }
  end

  rescue_from(ActionController::ParameterMissing) do |e|
    render json:   { error: e.message },
           status: :bad_request
  end

  private

  def build_json
    search_results = ItaTaxonomy.search_related_terms(q: @query_expansion, types: 'Countries')

    @related_terms = {}
    parse_query_expansion(search_results)

    @query_expansion = strip_punctuation(@query_expansion)

    @related_terms.each { |_key, array| build_queries(array) }
    @related_terms
  end

  def build_queries(array)
    array.map! do |label|
      { label.to_sym => "#{@query_expansion} #{label}".strip.gsub(/\s+/, ' ') }
    end
  end

  def strip_punctuation(string)
    string.downcase.gsub(/[^a-z0-9\s]/i, '')
  end

  def parse_query_expansion(search_results)
    search_results.each do |term|
      if @query_expansion.include?(term[:label].downcase)
        @related_terms.merge!(term[:related_terms]) { |_key, old_val, new_val| old_val | new_val }
        @query_expansion.slice!(term[:label].downcase)
      end
    end
  end
end
