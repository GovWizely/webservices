class Api::V2::ParatureFaqController < Api::V2Controller
  include Searchable
  search_by :question, :answer, :update_date, :countries, :industries, :q, :topics
end
