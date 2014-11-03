class Api::V1::TradeEvents::DlController < ApplicationController
  include Searchable
  search_by :countries, :industry, :q
end
