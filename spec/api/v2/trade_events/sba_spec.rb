require 'spec_helper'

describe 'SBA Trade Events API V2', type: :request do
  let(:api_version) { 2 }
  include_context 'TradeEvent::Sba data v2'
  let(:v2_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v2' } }

  describe 'GET /trade_events/sba/search' do
    let(:params) { { size: 100 } }
    before { get '/trade_events/sba/search', params, v2_headers }
    subject { response }

    context 'when search parameters are empty' do
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Sba results'
    end

    context 'when q is specified' do
      let(:params) { { q: 'Maximus' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Sba results that match "Maximus"'
    end

    context 'when countries is specified' do
      let(:params) { { countries: 'fr,de' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Sba results that match countries "fr,de"'
    end
  end
end
