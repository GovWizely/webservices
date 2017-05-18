class Api::V2::AdminController < Api::V2Controller
  respond_to :json
  before_action :authorize_by_api_key

  def freshen
    url = "#{versioned_api_prefix}/freshen"
    response = Net::HTTP.get(URI.parse(url))
    respond_with response
  end

  private

  def authorize_by_api_key
    api_key = params[:api_key] || request.headers['Api-Key']

    unless api_key && User.to_adapter.find_first(api_key: api_key).admin?
      render json: { error: 'Unauthorized.' }, status: :unauthorized
    end
  end
end
