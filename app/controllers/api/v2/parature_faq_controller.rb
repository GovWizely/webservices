class Api::V2::ParatureFaqController < Api::V2Controller
  search_by :question, :answer, :update_date, :countries, :industries, :q, :topics
end
