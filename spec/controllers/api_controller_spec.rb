require 'spec_helper'

describe ApiController, type: :controller do
  class InheritsFromApiController < ApiController
    def foo
      ActionController::Parameters.new(params).permit([:q])
      render text: 'ok', status: :ok
    end

    def new_query
      Query.new(params)
    end
  end

  describe InheritsFromApiController do
    before do
      Rails.application.routes.draw do
        get '/foo' => 'inherits_from_api#foo'
        get '/not_found' => 'inherits_from_api#not_found'
        get '/new_query' => 'inherits_from_api#new_query'
      end
    end
    after { Rails.application.reload_routes! }

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

      context 'query with negative offset' do
        before { get :new_query, offset: -1 }
        it { expect(response.status).to eq(400) }
        it { expect(response.body).to include('Offset must be greater than or equal to 0') }
      end
    end
  end
end
