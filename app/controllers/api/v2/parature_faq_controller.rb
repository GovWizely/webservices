class Api::V2::ParatureFaqController < ApplicationController
  include Searchable
  search_by :question, :answer, :update_date_start, :update_date_end, :countries, :industries, :q, :topics
end
