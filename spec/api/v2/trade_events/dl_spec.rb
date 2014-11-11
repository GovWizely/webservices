require 'spec_helper'

describe 'DL Trade Events API V2', type: :request do
  include_context 'TradeEvent::Dl data v2'
  let(:v2_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v2' } }

  describe 'GET /trade_events/dl/search' do
    let(:params) { { size: 100 } }
    before { get '/trade_events/dl/search', params, v2_headers }
    subject { response }

    context 'when search parameters are empty' do
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Dl results'
    end

    context 'when q is specified' do
      let(:params) { { q: 'Bangladesh' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Dl results that match "Bangladesh"'
    end
  end
end
