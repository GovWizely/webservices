class Api::V1::UstdaEventsController < ApplicationController
  include Searchable
  search_by :countries, :industry, :q
end
