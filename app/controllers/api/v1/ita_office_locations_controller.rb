class Api::V1::ItaOfficeLocationsController < ApplicationController
  include Searchable
  search_by :countries, :country, :state, :city, :q

  alias_method :standart_search, :search
  def search
    params[:countries] = params[:country]
    standart_search
  end
end
