class Api::V2::ItaTaxonomyController < Api::V2Controller
  include Searchable
  search_by :q, :types, :labels

  def query_expansion
    @q = params.permit(search_params).require(:q).downcase

    @results = QueryExpansionGenerator.generate(@q)
  end

  rescue_from(ActionController::ParameterMissing) do |e|
    render json:   { error: e.message },
           status: :bad_request
  end
end
