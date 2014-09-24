class Api::V1::ScreeningLists::DtcController < ApplicationController
  include Searchable
  search_by :q
end
