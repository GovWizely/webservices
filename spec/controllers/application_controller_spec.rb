require 'spec_helper'

describe ApplicationController, type: :controller do
  describe '#not_found' do
    it 'responds with a 404 status' do
      get :not_found
      expect(response.status).to eq(404)
    end
  end
end
