require 'spec_helper'

describe 'Trade Events API V1' do
  include_context 'TradeEvent::Ustda data'

  describe 'GET /trade_events/ustda/search.json' do
    let(:v1_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v1' } }
    let(:params) { { size: 100 } }
    before { get '/trade_events/ustda/search', params, v1_headers }
    subject { response }

    context 'when search parameters are empty' do
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Ustda results'
    end

    context 'when q is specified' do
      let(:params) { { q: 'international' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Ustda results that match "international"'
    end

    context 'when countries is specified' do
      let(:params) { { countries: 'us' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Ustda results that match countries "US"'
    end
    context 'when industry is specified' do
      let(:params) { { industry: 'mining' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Ustda results that match industry "mining"'
    end
  end
end
