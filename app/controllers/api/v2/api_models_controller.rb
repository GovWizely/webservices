class Api::V2::ApiModelsController < Api::V2Controller
  respond_to :json
  before_action :setup_data_source
  before_action :setup_search_params

  def search
    query = ApiModelQuery.new(@data_source, params.permit(search_params).with_indifferent_access)
    respond_with search_class.search(query.generate_search_body_hash)
  end

  private

  def setup_data_source
    @data_source = DataSource.find(params[:resource])
  end

  def search_class
    params[:resource].classify.constantize
  end

  def setup_search_params
    fulltext_fields = @data_source.fulltext_fields.present? ? %i(q) : []
    self.search_params = %i(api_key callback format offset size resource) +
      @data_source.filter_fields.keys +
      fulltext_fields +
      @data_source.date_fields.keys
  end

end
