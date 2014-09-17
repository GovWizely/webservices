class Api::V1::ParatureFaqController < ApplicationController
	include Searchable
	search_by :question, :answer, :create_date, :update_date
end
