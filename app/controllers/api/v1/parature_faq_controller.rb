class Api::V1::ParatureFaqController < ApiController
  include Searchable
  search_by :question, :answer, :update_date, :countries, :industries, :q, :topics
end
