class DataSourcesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_data_source, only: [:show, :edit, :update, :destroy, :iterate_version]
  COMMON_PARAMS = %i(name api description url version_number consolidated s3_bucket_name)
  MESSAGES = { created:   'Data source was successfully created. Review the dictionary and make any changes.',
               destroyed: 'Dataset was successfully destroyed.',
               set_up:    'Consolidated data source was successfully set up',
               updated:   'Data source was successfully updated and data uploaded.',
  }

  def new
    @data_source = DataSource.new(version_number: 1, consolidated: params[:consolidated], name: '', api: '',
                                  description: '', s3_bucket_name: '', url: '',)
  end

  def iterate_version
    @data_source = DataSource.new(@data_source.attributes)
    @data_source.version_number += 1
    render :new
  end

  def create
    data_source_params = params.require(:data_source).permit(COMMON_PARAMS).merge(published: true)
                               .reverse_merge(consolidated: false,)
    @data_source = DataSource.new(data_source_params)
    if @data_source.save
      redirect_to edit_data_source_path(@data_source, just_created: true), notice: MESSAGES[:created]
    else
      render :new
    end
  end

  def edit
  end

  def update
    attributes = params.require(:data_source).permit(COMMON_PARAMS + %i(dictionary published))
    if @data_source.update_attributes(attributes)
      notice = @data_source.is_consolidated? ? MESSAGES[:set_up] : MESSAGES[:updated]
      redirect_to data_source_path(@data_source), notice: notice
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

  def set_data_source
    @data_source = DataSource.find(params[:id])
  end
end
