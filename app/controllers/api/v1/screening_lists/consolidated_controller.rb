class Api::V1::ScreeningLists::ConsolidatedController < ApiController
  search_by :countries, :q, :type, :sources, :name, :distance, :address

  def sv_filename
    "CSL_#{Time.now.strftime('%Y_%m_%d')}"
  end
end
