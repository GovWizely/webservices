class Api::V1::TradeArticlesController < ApplicationController
  include Searchable

  alias_method :standart_search, :search
	def search
		params[:countries] = params[:country]
		standart_search()
	end

  search_by :evergreen, :pub_date_start, :pub_date_end, :update_date_start, :update_date_end, :q, :country, :countries
end
