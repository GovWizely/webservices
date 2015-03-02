require 'spec_helper'

describe ApiController, type: :controller do
  # include_context 'V2 headers'
  describe '#not_found' do
    it 'responds with a 404 status' do
      get :not_found
      expect(response.status).to eq(404)
    end
  end
end
