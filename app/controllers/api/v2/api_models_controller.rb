class Api::V2::ApiModelsController < Api::V2Controller
  respond_to :json

  def search
    query_params = params.except(:api, :api_key, :version_number, :controller, :action, :format).to_query
    url = "#{versioned_api_prefix}/search?#{query_params}"
    response = Net::HTTP.get(URI.parse(url))
    respond_with response
  end

  def show
    url = "#{versioned_api_prefix}/#{params['id']}"
    response = Net::HTTP.get(URI.parse(url))
    respond_with response
  end
end
