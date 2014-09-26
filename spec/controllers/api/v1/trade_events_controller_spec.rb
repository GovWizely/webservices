require 'spec_helper'

describe Api::V1::TradeEventsController do
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
      TradeEvent.should_receive(:search_for).with(search_params).and_return(search)
      get :search,
          bogus_param: 'bogus value',
          countries:   'MX',
          format:      :json,
          industry:    'fishing',
          offset:      '1',
          q:           'trade',
          size:        '15'
    end

    it { should respond_with(:success) }
  end
end
