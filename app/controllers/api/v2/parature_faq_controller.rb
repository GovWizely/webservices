class Api::V2::ParatureFaqController < ApplicationController
  include Searchable
  search_by :question, :answer, :update_date, :countries, :industries, :q, :topics
end
