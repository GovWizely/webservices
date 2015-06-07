class Api::V2::ItaZipCodesController < Api::V2Controller
  search_by :zip_codes, :q
end
