class ApiController < ActionController::Base
  class_attribute :search_params, instance_writer: false
  self.search_params = %i(api_key callback format offset size)

  def self.search_by(*permitted)
    self.search_params |= permitted
  end

  ActionController::Parameters.action_on_unpermitted_parameters = :raise

  rescue_from(ActionController::UnpermittedParameters) do |e|
    render json:   { error:  { unknown_parameters: e.params } },
           status: :bad_request
  end

  rescue_from(Query::InvalidParamsException) do |e|
    render json:   { errors: e.errors },
           status: :bad_request
  end

  respond_to :json, :csv, :tsv

  def query_info_fields
    [:total, :offset, :sources_used]
  end

  def search
    s = params.permit(search_params).except(:format)
    s.merge!(api_version: api_version)

    respond_to do |format|
      format.csv { render_sv('csv') }
      format.tsv { render_sv('tsv') }
      format.json do
        @query_info_fields = query_info_fields
        @search =
          if s[:size].to_i == -1
            search_class.fetch_all(sources)
          else
            search_class.search_for(s)
          end
        render
      end
    end
  end

  def not_found
    render json: { error: 'Not Found' }, status: :not_found
  end

  private

  def sources
    sources = Array(params.fetch(:sources, []))
    sources.map!(&:upcase)
    sources.empty? ? nil : sources
  end

  def api_version
    self.class.name.match(/Api::V(\d+)::/) { |m| m[1] }
  end

  def search_class
    parts = self.class.name.gsub(/Controller|Api::V\d+::/, '').split('::')
    parts[0] = parts[0].singularize
    parts.join('::').constantize
  end

  def render_sv(format)
    search = search_class.fetch_all[:hits]
    send_data(
      search_class.send("as_#{format}", search),
      type:        "Mime::#{format.upcase}".constantize,
      disposition: "attachment; filename=#{sv_filename}.#{format}")
  end

  def sv_filename
    'search'
  end
end
