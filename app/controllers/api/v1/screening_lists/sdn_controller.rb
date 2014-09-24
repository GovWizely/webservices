class Api::V1::ScreeningLists::SdnController < ApplicationController
  include Searchable
  search_by :countries, :q, :sdn_type
end
