require 'spec_helper'

describe 'FTA Morocco Tariff Rates API V1', type: :request do
  include_context 'TariffRate::Morocco data'

  describe 'GET /v1/tariff_rates/search?sources=MA' do
    let(:params) { { sources: 'ma' } }
    before { get '/v1/tariff_rates/search', params }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'it contains all TariffRate::Morocco results'
      it_behaves_like 'a successful search request'
    end

    context 'when q is specified' do
      let(:params) { { sources: 'ma', q: 'horses' } }

      subject { response }
      it_behaves_like 'a successful search request'
      it_behaves_like "an empty result when a query doesn't match any documents", sources: 'ma'
      it_behaves_like 'it contains all TariffRate::Morocco results that match "horses"'
    end
  end
end
