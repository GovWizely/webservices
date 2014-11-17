class Api::V2::ScreeningLists::SdnController < ApplicationController
  include Searchable
  search_by :countries, :q, :type
end
