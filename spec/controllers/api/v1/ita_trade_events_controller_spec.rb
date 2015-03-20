require 'spec_helper'

describe Api::V1::TradeEvents::ItaController, type: :controller do
  describe '#search' do
    let(:search_params) do
      { 'countries'   => 'MX',
        'industry'    => 'fishing',
        'offset'      => '1',
        'q'           => 'trade',
        'size'        => '15',
        'api_version' => '1',
      }
    end
    let(:search) { double('search') }

    before do
      expect(TradeEvent::Ita).to receive(:search_for).with(search_params).and_return(search)
      get :search,
          countries: 'MX',
          format:    :json,
          industry:  'fishing',
          offset:    '1',
          q:         'trade',
          size:      '15'
    end

    it { is_expected.to respond_with(:success) }
  end
end
