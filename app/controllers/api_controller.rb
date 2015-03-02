class ApiController < ActionController::Base
  def not_found
    render json: { error: 'Not Found' }, status: :not_found
  end
end
