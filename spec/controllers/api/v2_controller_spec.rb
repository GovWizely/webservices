require 'spec_helper'

shared_context 'user with API Key' do
  before do
    user
    User.gateway.refresh_index!
  end
  let(:user) { create_user }
  after do
    user.destroy
    User.gateway.refresh_index!
  end
end

describe Api::V2Controller, type: :controller do
  class InheritsFromApiV2Controller < described_class
    def foo
      render text: 'ok', status: :ok
    end

    def bad_date_range
      raise Exceptions::InvalidDateRangeFormat
    end
  end

  describe InheritsFromApiV2Controller do
    before do
      Rails.application.routes.draw do
        get '/foo' => 'inherits_from_api_v2#foo'
        get '/bad_date_range' => 'inherits_from_api_v2#bad_date_range'
      end
    end
    after { Rails.application.reload_routes! }

    describe 'auth' do
      context 'with unknown API Key' do
        context 'when given via params' do
          it 'responds with 401 unauthorized' do
            get :foo, api_key: 'probablynevergoingtobeavalidkey'
            expect(response.status).to eq(401)
          end
        end
        context 'when given via headers' do
          it 'responds with 401 unauthorized' do
            get :foo, {}, 'Api-Key' => 'probablynevergoingtobeavalidkey'
            expect(response.status).to eq(401)
          end
        end
      end

      context 'with known API Key' do
        include_context 'user with API Key'

        context 'when given via params' do
          it 'responds with 200 ok' do
            get :foo, api_key: user.api_key
            expect(response.status).to eq(200)
          end
        end
        context 'when given via headers' do
          it 'responds with 200 ok' do
            request.headers['Api-Key'] = user.api_key
            get :foo
            expect(response.status).to eq(200)
          end
        end
        context 'with invalid date range exception' do
          it 'responds with 400 error' do
            request.headers['Api-Key'] = user.api_key
            get :bad_date_range
            expect(response.status).to eq(400)
          end
        end
      end
    end
  end
end
