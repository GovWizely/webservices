class Api::V2::ItaZipCodesController < Api::V2Controller
  include Searchable
  search_by :zip_codes, :q
end
