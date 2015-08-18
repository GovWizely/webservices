require 'spec_helper'

describe 'FTA Colombia Tariff Rates API V1', type: :request do
  include_context 'TariffRate::Colombia data'

  describe 'GET /v1/tariff_rates/search?sources=CO' do
    let(:params) { { sources: 'co' } }
    before { get '/v1/tariff_rates/search', params }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'it contains all TariffRate::Colombia results'
      it_behaves_like 'a successful search request'
    end

    context 'when q is specified' do
      let(:params) { { sources: 'co', q: 'horses' } }

      subject { response }
      it_behaves_like 'a successful search request'
      it_behaves_like "an empty result when a query doesn't match any documents", sources: 'co'
      it_behaves_like 'it contains all TariffRate::Colombia results that match "horses"'
    end
  end
end
