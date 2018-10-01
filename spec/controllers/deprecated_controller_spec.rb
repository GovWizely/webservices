require 'spec_helper'

describe DeprecatedController do
  render_views

  before do
    Rails.application.routes.draw do
      get '/deprecated/mrl' => 'deprecated#mrl'
    end
  end
  after { Rails.application.reload_routes! }

  describe '#mrl' do
    it 'responds correctly' do
      get :mrl
      expect(response.status).to eq(200)
      expect(response.body).to include('The Market Research Library API was retired')
    end
  end
end
