class Api::V1::ItaOfficeLocationsController < ApplicationController
  include Searchable
  search_by :countries, :country, :state, :city, :q
  def search
    params[:countries] = params[:country]
    super
  end
end
