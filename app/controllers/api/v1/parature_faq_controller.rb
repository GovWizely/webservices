class Api::V1::ParatureFaqController < ApplicationController
	include Searchable
	search_by :question
end
