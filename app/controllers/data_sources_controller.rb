class DataSourcesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_data_source, only: [:show, :edit, :update, :destroy, :iterate_version]
  rescue_from Elasticsearch::Transport::Transport::Errors::Conflict, with: :api_not_unique

  def new
    @data_source = DataSource.new(version_number: 1)
  end

  def iterate_version
    @data_source = DataSource.new(name: @data_source.name, api: @data_source.api, description: @data_source.description,
                                  version_number: @data_source.version_number + 1)

    render :new
  end

  def create
    data_source_params = params.require(:data_source).permit(:name, :api, :description, :path, :version_number)
    versioned_id = DataSource.id_from_params(data_source_params['api'], data_source_params['version_number'])
    attributes = data_source_params.merge(_id: versioned_id, data: params['data_source']['path'].read, published: false)
    @data_source = DataSource.new(attributes)
    if @data_source.save(op_type: :create, refresh: true)
      redirect_to edit_data_source_path(@data_source, just_created: true), notice: 'Data source was successfully created. Review the schema and make any changes.'
    else
      render :new
    end
  end

  def edit
    @data_source.dictionary = @data_source.yaml_dictionary.deep_stringify_keys.to_yaml
  end

  def update
    attributes = params.require(:data_source).permit(:name, :api, :description, :dictionary, :version_number, :published, :path)
    attributes.merge!(data: params['data_source']['path'].read) if params['data_source']['path'].present?
    attributes[:dictionary] = YAML.load(attributes[:dictionary]).deep_symbolize_keys.to_yaml
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

  def set_data_source
    @data_source = DataSource.find(params[:id])
  end

  def api_not_unique
    @data_source.errors.add(:api, "'#{@data_source.api}' already exists.")
    render :new
  end
end
