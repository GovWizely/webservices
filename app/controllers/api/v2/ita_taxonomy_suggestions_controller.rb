class Api::V2::ItaTaxonomySuggestionsController < Api::V2Controller
  before_action :require_term

  search_by :term

  private

  def require_term
    if params[:term].blank? || params.permit(search_params)[:term].squish.length < 2
      render json: { error: '`term` parameter is required and it must be at least 2 characters long' }, status: :bad_request
    end
  end
end
