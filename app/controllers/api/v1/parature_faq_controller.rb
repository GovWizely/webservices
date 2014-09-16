class Api::V1::ParatureFaqController < ApplicationController
	include Searchable
	search_by :question, :create_date, :update_date
end
