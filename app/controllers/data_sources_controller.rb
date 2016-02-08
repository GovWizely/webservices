class DataSourcesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_data_source, only: [:show, :edit, :update, :destroy, :iterate_version]
  rescue_from Elasticsearch::Transport::Transport::Errors::Conflict, with: :api_not_unique
  COMMON_PARAMS = %i(name api description path url version_number)

  def new
    @data_source = DataSource.new(version_number: 1)
  end

  def iterate_version
    @data_source = DataSource.new(name: @data_source.name, api: @data_source.api, description: @data_source.description,
                                  version_number: @data_source.version_number + 1)

    render :new
  end

  def create
    data_source_params = params.require(:data_source).permit(COMMON_PARAMS)
    resource = data_source_params[:url].present? ? data_source_params[:url] : data_source_params.delete(:path)
    data_extractor = DataSources::DataExtractor.new(resource)
    @data_source = DataSource.new(data_source_params.merge(published: false, data: data_extractor.data))
    if @data_source.save(op_type: :create, refresh: true)
      redirect_to edit_data_source_path(@data_source, just_created: true), notice: 'Data source was successfully created. Review the schema and make any changes.'
    else
      render :new
    end
  end

  def edit
    @data_source.dictionary = @data_source.metadata.deep_stringified_yaml
  end

  def update
    attributes = params.require(:data_source).permit(COMMON_PARAMS + %i(dictionary published))
    if attributes[:path].present?
      data_extractor = DataSources::DataExtractor.new(attributes.delete(:path))
      attributes.merge!(data: data_extractor.data)
    end
    attributes[:dictionary] = symbolized_yaml(attributes[:dictionary])
    @data_source.update(attributes) && @data_source.ingest
    redirect_to data_source_path(@data_source), notice: 'Data source was successfully updated and data uploaded.'
  end

  def show
  end

  def destroy
    @data_source.destroy
    redirect_to '/', notice: 'Dataset was successfully destroyed.'
  end

  private

  def symbolized_yaml(dictionary)
    DataSources::Metadata.new(dictionary).deep_symbolized_yaml
  end

  def set_data_source
    args = request['action'] == 'update' ? {} : { _source_exclude: 'data' }
    @data_source = DataSource.find(params[:id], args)
  end

  def api_not_unique
    @data_source.errors.add(:api, "'#{@data_source.api}' already exists.")
    render :new
  end
end
