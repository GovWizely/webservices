require 'spec_helper'

describe 'ITA Trade Events API V1', type: :request do
  include_context 'TradeEvent::Ita data'
  let(:v1_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v1' } }

  describe 'GET /trade_events/ita/search' do
    let(:params) { {} }
    before { get '/trade_events/ita/search', params, v1_headers }
    subject { response }

    context 'when search parameters are empty' do
      it_behaves_like 'it contains all TradeEvent::Ita results'
      it_behaves_like 'a successful search request'
    end

    context 'when q is specified' do
      let(:params) { { q: '2013' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Ita results that match "2013"'
    end

    context 'when countries is specified' do
      let(:params) { { countries: 'il' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Ita results that match countries "il"'
    end

    context 'when industry is specified' do
      let(:params) { { industry: 'DENTALS' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Ita results that match industry "DENTALS"'
    end

    context 'when searching for field with non ascii characters using ascii characters' do
      let(:params) { { q: 'Sao' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Ita results that match "Sao"'
    end
  end
end
