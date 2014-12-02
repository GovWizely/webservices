require 'spec_helper'

describe 'FTA Guatemala Tariff Rates API V1', type: :request do
  include_context 'TariffRate::Guatemala data'
  let(:v1_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v1' } }

  describe 'GET /tariff_rates/guatemala/search' do
    let(:params) { {} }
    before { get '/tariff_rates/guatemala/search', params, v1_headers }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'it contains all TariffRate::Guatemala results'
      it_behaves_like 'a successful search request'
    end

    context 'when q is specified' do
      let(:params) { { q: 'horses' } }

      subject { response }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TariffRate::Guatemala results that match "horses"'
      it_behaves_like "an empty result when a query doesn't match any documents"

    end
  end
end
