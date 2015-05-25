class Api::V1::ScreeningLists::ConsolidatedController < ApiController
  search_by :countries, :q, :type, :sources, :name, :fuzziness, :address
end
