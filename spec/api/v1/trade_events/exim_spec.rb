require 'spec_helper'

xdescribe 'EXIM Trade Events API V1', type: :request do
  include_context 'TradeEvent::Exim data'

  describe 'GET /v1/trade_events/exim/search' do
    let(:params) { { size: 100 } }
    before { get '/v1/trade_events/exim/search', params }
    subject { response }

    context 'when search parameters are empty' do
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Exim results'
    end

    context 'when q is specified' do
      let(:params) { { q: 'Baltimore' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Exim results that match "Baltimore"'
      it_behaves_like "an empty result when a query doesn't match any documents"
    end
  end
end
