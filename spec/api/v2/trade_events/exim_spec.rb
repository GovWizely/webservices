require 'spec_helper'

describe 'EXIM Trade Events API V2', type: :request do
  include_context 'V2 headers'
  include_context 'TradeEvent::Exim data v2'

  describe 'GET /trade_events/exim/search' do
    let(:params) { { size: 100 } }
    before { get '/trade_events/exim/search', params, @v2_headers }
    subject { response }

    context 'when search parameters are empty' do
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Exim results'
    end

    context 'when q is specified' do
      let(:params) { { q: 'Baltimore' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Exim results that match "Baltimore"'
    end

  end
end
