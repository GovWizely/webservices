require 'spec_helper'

describe ApiController, type: :controller do

  class InheritsFromApiController < described_class
    def foo
      ActionController::Parameters.new(params).permit([:q])
      render text: 'ok', status: :ok
    end
  end

  describe InheritsFromApiController do
    before do
      Rails.application.routes.draw do
        get '/foo' => 'inherits_from_api#foo'
        get '/not_found' => 'inherits_from_api#not_found'
      end
    end
    after  { Rails.application.reload_routes! }

    describe '#not_found' do
      it 'responds with a 404 status' do
        get :not_found
        expect(response.status).to eq(404)
      end
    end

    describe '#foo' do
      it 'responds with 200' do
        get :foo, q: :freddy
        expect(response.status).to eq(200)
      end

      context 'with unpermitted parameter' do
        it 'responds with 400' do
          get :foo, a: :b
          expect(response.status).to eq(400)
        end
      end
    end

  end
end
