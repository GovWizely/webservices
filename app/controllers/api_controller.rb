class ApiController < ActionController::Base
  ActionController::Parameters.action_on_unpermitted_parameters = :raise

  rescue_from(ActionController::UnpermittedParameters) do |e|
    render json:   { error:  { unknown_parameters: e.params } },
           status: :bad_request
  end

  rescue_from(Query::InvalidParamsException) do |e|
    render json:   { errors: e.errors },
           status: :bad_request
  end

  def not_found
    render json: { error: 'Not Found' }, status: :not_found
  end
end
