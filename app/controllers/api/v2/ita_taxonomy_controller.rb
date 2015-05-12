class Api::V2::ItaTaxonomyController < Api::V2Controller
  include Searchable
  search_by :q, :taxonomies
end
