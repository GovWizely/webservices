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
    versioned_id = DataSource.id_from_params params[:api], params[:version_number]
    query_hash = { filter: { and: [{ term: { _id: versioned_id } }, { term: { published: true } }] } }
    @data_source = DataSource.search(query_hash, _source: { exclude: ['data'] }).first
    not_found unless @data_source.present?
  end

  def setup_search_params
    fulltext_fields = @data_source.fulltext_fields.present? ? %i(q) : []
    self.search_params = %i(api_key callback format offset size api version_number) +
      @data_source.filter_fields.keys +
      fulltext_fields +
      @data_source.date_fields.keys
  end

  def response_hash(query, results)
    { total: results.total, offset: query.offset, sources_used: sources_used, search_performed_at: search_performed_at, results: results }
  end

  def sources_used
    { source: @data_source.name, source_last_updated: @data_source.updated_at, last_imported: @data_source.updated_at }
  end

  def search_performed_at
    DateTime.now.utc
  end
end
