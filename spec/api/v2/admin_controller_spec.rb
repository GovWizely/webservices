require 'spec_helper'

describe Api::V2::AdminController, type: :request do
  include_context 'V2 headers'

  context 'admin user' do
    let(:data_source) { double(DataSource, id: 'myrecords:v1') }

    before(:all) do
      @user.admin = true
      @user.save
      User.gateway.refresh_index!
    end

    after(:all) do
      @user.admin = false
      @user.save
      User.gateway.refresh_index!
    end

    describe 'freshen.json' do
      context 'endpoint exists' do
        before do
          expect(DataSource).to receive(:find_published).with('myrecords', '1').and_return(data_source)
          expect(data_source).to receive(:freshen)
          expect(DataSource).to receive(:refresh_index!)
          get '/v1/myrecords/freshen', {}, @v2_headers
        end

        subject { response }

        it 'returns success' do
          json_response = JSON.parse(response.body)
          expect(json_response).to match('success' => 'myrecords:v1 API freshened')
        end
      end

      context 'endpoint does not exist' do
        before do
          get '/v9/nope/freshen', {}, @v2_headers
        end

        subject { response }

        specify { expect(subject.status).to eq(404) }
      end
    end
  end

  context 'non-admin user' do
    describe 'freshen.json' do
      before do
        get '/v1/myrecords/freshen', {}, @v2_headers
      end

      subject { response }

      specify { expect(subject.status).to eq(401) }
    end
  end
end
