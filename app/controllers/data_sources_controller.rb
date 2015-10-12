class DataSourcesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_data_source, only: [:show, :edit, :update, :destroy]

  def new
    @data_source = DataSource.new
  end

  def create
    data_source_params = params.require(:data_source).permit(:name, :api, :description, :path)
    @data_source = DataSource.new(data_source_params.merge(_id: data_source_params['api'], data: params['data_source']['path'].read))
    if @data_source.save
      redirect_to edit_data_source_path(@data_source), notice: 'Data source was successfully created. Review the schema and make any changes.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    @data_source.update(params.require(:data_source).permit(:name, :api, :description, :dictionary)) && @data_source.ingest
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
end
