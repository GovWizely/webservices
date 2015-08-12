require 'spec_helper'

describe Api::V1::ItaOfficeLocationsController, type: :controller do
  describe '#search' do
    context 'with valid parameters' do
      before do
        expect(ItaOfficeLocation).to receive(:search_for).and_return(double('search'))
      end

      it 'responds correctly with full params' do
        get :search,
            country: 'US',
            format:  :json,
            state:   'DC',
            city:    'Washington',
            q:       'national'

        expect(response.status).to eq(200)
      end

      it 'responds correctly with empty country param' do
        get :search, format: :json, country: ''

        expect(response.status).to eq(200)
      end

      it 'responds correctly with empty state param' do
        get :search, format: :json, state: ''

        expect(response.status).to eq(200)
      end
    end
  end
end
