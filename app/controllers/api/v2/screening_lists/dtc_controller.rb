class Api::V2::ScreeningLists::DtcController < ApplicationController
  include Searchable
  search_by :q
end
