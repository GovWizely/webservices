class Api::V2Controller < ApiController
  before_action :authenticate_by_api_key

  rescue_from(Exceptions::InvalidDateRangeFormat) do |_e|
    render json:   { error:  'Invalid Date Range Format' },
           status: :bad_request
  end

  private

  def authenticate_by_api_key
    api_key = params[:api_key] || request.headers['Api-Key']

    unless api_key && User.to_adapter.find_first(api_key: api_key)
      render json: { error: 'Unauthorized - Please get a new key at https://api.trade.gov' }, status: :unauthorized
    end
  end

  def versioned_api_prefix
    "#{Rails.configuration.endpointme_url}/v#{params['version_number']}/#{params['api']}"
  end
end
