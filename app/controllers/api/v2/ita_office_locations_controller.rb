class Api::V2::ItaOfficeLocationsController < ApplicationController
  include Searchable

  alias_method :standart_search, :search
  def search
    params[:country] = params[:countries]
    standart_search
  end

  search_by :countries, :country, :state, :city, :q
end
