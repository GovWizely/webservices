class Api::V2::ApiModelsController < Api::V2Controller
  respond_to :json
  before_action :setup_data_source
  before_action :setup_search_params

  def search
    query = ApiModelQuery.new(@data_source, params.permit(search_params).with_indifferent_access)
    @data_source.with_api_model do |api_model_klass|
      results = api_model_klass.search(query.generate_search_body_hash)
      respond_with response_hash(query, results)
    end
  end

  private

  def setup_data_source
    @data_source = DataSource.search(filter: { term: { _id: params[:resource] } }, _source: { exclude: ['data'] }).first
    fail ActionController::RoutingError.new('Search index cannot be found') unless @data_source.present?
  end

  def setup_search_params
    fulltext_fields = @data_source.fulltext_fields.present? ? %i(q) : []
    self.search_params = %i(api_key callback format offset size resource) +
      @data_source.filter_fields.keys +
      fulltext_fields +
      @data_source.date_fields.keys
  end

  def response_hash(query, results)
    { total: results.total, offset: query.offset, sources_used: sources_used, results: results }
  end

  def sources_used
    { source: @data_source.name, source_last_updated: @data_source.updated_at, last_imported: @data_source.updated_at }
  end
end
