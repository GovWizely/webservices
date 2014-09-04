require 'spec_helper'

describe Api::V1::ItaOfficeLocationsController do
  describe '#search' do
    let(:search_params) {
      { 'country' => 'US',
        'state' => 'DC',
        'city' => 'Washington',
        'q' => 'national' }
    }
    let(:search) { double('search') }

    before do
      ItaOfficeLocation.should_receive(:search_for).with(search_params).and_return(search)
      get :search,
          bogus_param: 'bogus value',
          country: 'US',
          format: :json,
          state: 'DC',
          city: 'Washington',
          q: 'national'
    end

    it { should respond_with(:success) }
  end
end
