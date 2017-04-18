class DataSourcesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_data_source, only: [:show, :edit, :update, :destroy, :iterate_version]
  rescue_from Elasticsearch::Transport::Transport::Errors::Conflict, with: :api_not_unique
  COMMON_PARAMS = %i(name api description path url version_number consolidated s3_bucket_name)
  MESSAGES = { created:   'Data source was successfully created. Review the dictionary and make any changes.',
               destroyed: 'Dataset was successfully destroyed.',
               set_up:    'Consolidated data source was successfully set up',
               updated:   'Data source was successfully updated and data uploaded.',
  }

  def new
    @data_source = DataSource.new(version_number: 1, consolidated: params[:consolidated])
  end

  def iterate_version
    @data_source = DataSource.new(name: @data_source.name, api: @data_source.api, description: @data_source.description,
                                  version_number: @data_source.version_number + 1,)

    render :new
  end

  def create
    data_source_params = params.require(:data_source).permit(COMMON_PARAMS)
    attributes = { published: true }
    unless data_source_params[:consolidated]
      resource = data_source_params[:url].present? ? data_source_params[:url] : data_source_params.delete(:path)
      data_extractor = DataSources::DataExtractor.new(resource)
      attributes[:data] = data_extractor.data
    end
    @data_source = DataSource.new(data_source_params.merge(attributes))
    if @data_source.save(op_type: :create, refresh: true)
      redirect_to edit_data_source_path(@data_source, just_created: true), notice: MESSAGES[:created]
    else
      render :new
    end
  end

  def edit
    @data_source.dictionary = @data_source.metadata.deep_stringified_yaml unless @data_source.is_consolidated?
  end

  def update
    attributes = params.require(:data_source).permit(COMMON_PARAMS + %i(dictionary published))
    attributes[:data] = DataSources::DataExtractor.new(attributes.delete(:path)).data if attributes[:path].present?
    attributes[:dictionary] = symbolized_yaml(attributes[:dictionary]) unless @data_source.is_consolidated?
    @data_source.name = attributes['name']
    if @data_source.update(attributes)
      perform_update
    else
      render :edit
    end
  end

  def show
  end

  def destroy
    @data_source.destroy
    redirect_to '/', notice: MESSAGES[:destroyed]
  end

  def documentation
  end

  private

  def symbolized_yaml(dictionary)
    DataSources::Metadata.new(dictionary).deep_symbolized_yaml
  end

  def perform_update
    @data_source.ingest unless @data_source.is_consolidated?
    DataSource.refresh_index!
    notice = @data_source.is_consolidated? ? MESSAGES[:set_up] : MESSAGES[:updated]
    redirect_to data_source_path(@data_source), notice: notice
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
