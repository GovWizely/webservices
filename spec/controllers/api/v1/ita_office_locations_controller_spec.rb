require 'spec_helper'

describe Api::V1::ItaOfficeLocationsController, type: :controller do
  describe '#search' do
    let(:search_params) do
      {
        'countries' => 'US',
        'country'   => 'US',
        'state'     => 'DC',
        'city'      => 'Washington',
        'q'         => 'national' }
    end
    let(:search) { double('search') }

    before do
      expect(ItaOfficeLocation).to receive(:search_for).with(search_params).and_return(search)
      get :search,
          bogus_param: 'bogus value',
          country:     'US',
          format:      :json,
          state:       'DC',
          city:        'Washington',
          q:           'national'
    end

    it { is_expected.to respond_with(:success) }
  end
end
