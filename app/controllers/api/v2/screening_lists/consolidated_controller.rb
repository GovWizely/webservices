class Api::V2::ScreeningLists::ConsolidatedController < Api::V2Controller
  search_by :countries, :q, :type, :sources, :name, :distance, :address,
            :end_date, :start_date, :expiration_date, :issue_date, :fuzzy_name,
            :fuzzy_address

  private

  def sv_filename
    "CSL_#{Time.now.strftime('%Y_%m_%d')}"
  end
end
