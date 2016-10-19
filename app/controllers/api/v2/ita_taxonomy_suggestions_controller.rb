class Api::V2::ItaTaxonomySuggestionsController < Api::V2Controller
  before_action :require_label

  search_by :label

  private

  def require_label
    if params[:label].blank? || params.permit(search_params)[:label].squish.length < 2
      render json: { error: '`label` parameter is required and it must be at least 2 characters long' }, status: :bad_request
    end
  end
end
