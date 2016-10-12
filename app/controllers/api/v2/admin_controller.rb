class Api::V2::AdminController < Api::V2Controller
  respond_to :json
  before_action :authorize_by_api_key
  before_action :setup_data_source

  def freshen
    @data_source.freshen
    DataSource.refresh_index!
    render json: { success: "#{@data_source.id} API freshened" }, status: :ok
  end

  private

  def authorize_by_api_key
    api_key = params[:api_key] || request.headers['Api-Key']

    unless api_key && User.to_adapter.find_first(api_key: api_key).admin?
      render json: { error: 'Unauthorized.' }, status: :unauthorized
    end
  end

  def setup_data_source
    @data_source = DataSource.find_published(params[:api], params[:version_number])
    not_found unless @data_source.present?
  end
end
