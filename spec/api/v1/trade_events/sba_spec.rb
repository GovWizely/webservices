require 'spec_helper'

describe 'SBA Trade Events API V1', type: :request do
  include_context 'TradeEvent::Sba data'

  describe 'GET /v1/trade_events/sba/search' do
    let(:params) { { size: 100 } }
    before { get '/v1/trade_events/sba/search', params }
    subject { response }

    context 'when search parameters are empty' do
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Sba results'
    end

    context 'when q is specified' do
      let(:params) { { q: 'Maximus' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Sba results that match "Maximus"'
      it_behaves_like "an empty result when a query doesn't match any documents"
    end

    context 'when countries is specified' do
      let(:params) { { countries: 'fr,de' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Sba results that match countries "fr,de"'
    end
  end
end
