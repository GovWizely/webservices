class Api::V1::BisDeniedPeopleController < ApplicationController
  include Searchable
  search_by :countries, :q, :sdn_type
end
