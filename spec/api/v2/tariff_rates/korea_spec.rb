require 'spec_helper'

describe 'FTA Korea Tariff Rates API V2', type: :request do
  include_context 'TariffRate::Korea data'
  let(:v2_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v2' } }

  describe 'GET /tariff_rates/korea/search' do
    let(:params) { {} }
    before { get '/tariff_rates/korea/search', params, v2_headers }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'it contains all TariffRate::Korea results'
      it_behaves_like 'a successful search request'
    end

    context 'when q is specified' do
      let(:params) { { q: 'horses' } }

      subject { response }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TariffRate::Korea results that match "horses"'

    end
  end
end
