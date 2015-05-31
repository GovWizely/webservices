class Api::V2::ScreeningLists::ConsolidatedController < Api::V2Controller
  search_by :countries, :q, :type, :sources, :name, :fuzziness, :address, :end_date, :start_date, :expiration_date, :issue_date

  private

  def sv_filename
    "CSL_#{Time.now.strftime('%Y_%m_%d')}"
  end
end
