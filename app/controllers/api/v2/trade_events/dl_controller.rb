class Api::V2::TradeEvents::DlController < ApplicationController
  include Searchable
  search_by :q
end
