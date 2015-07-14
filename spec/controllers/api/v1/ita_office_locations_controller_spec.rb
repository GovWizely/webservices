require 'spec_helper'

describe Api::V1::ItaOfficeLocationsController, type: :controller do
  describe '#search' do
    let(:search_params) do
      {
        'countries'   => 'US',
        'country'     => 'US',
        'state'       => 'DC',
        'city'        => 'Washington',
        'q'           => 'national',
        'api_version' => '1',
      }
    end
    context 'with valid parameters' do
      let(:search) { double('search') }

      before do
        expect(ItaOfficeLocation).to receive(:search_for).with(search_params).and_return(search)
        get :search,
            country: 'US',
            format:  :json,
            state:   'DC',
            city:    'Washington',
            q:       'national'
      end

      it { is_expected.to respond_with(:success) }
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
