require 'spec_helper'

describe Api::V1::ItaTradeEventsController, type: :controller do
  describe '#search' do
    let(:search_params) do
      { 'countries' => 'MX',
        'industry'  => 'fishing',
        'offset'    => '1',
        'q'         => 'trade',
        'size'      => '15' }
    end
    let(:search) { double('search') }

    before do
      expect(ItaTradeEvent).to receive(:search_for).with(search_params).and_return(search)
      get :search,
          bogus_param: 'bogus value',
          countries:   'MX',
          format:      :json,
          industry:    'fishing',
          offset:      '1',
          q:           'trade',
          size:        '15'
    end

    it { is_expected.to respond_with(:success) }
  end
end
