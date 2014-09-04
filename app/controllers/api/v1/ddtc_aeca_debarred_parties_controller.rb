class Api::V1::DdtcAecaDebarredPartiesController < ApplicationController
  include Searchable
  search_by :q
end
