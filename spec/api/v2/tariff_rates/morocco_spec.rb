require 'spec_helper'

describe 'FTA Morocco Tariff Rates API V2', type: :request do
  include_context 'V2 headers'
  include_context 'TariffRate::Morocco data'

  describe 'GET /tariff_rates/search?sources=MA' do
    let(:params) { { sources: 'ma' } }
    before { get '/v2/tariff_rates/search', params, @v2_headers }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'it contains all TariffRate::Morocco results'
      it_behaves_like 'a successful search request'
    end

    context 'when q is specified' do
      let(:params) { { sources: 'ma', q: 'horses' } }

      subject { response }
      it_behaves_like 'a successful search request'
      it_behaves_like "an empty result when a query doesn't match any documents"
      it_behaves_like 'it contains all TariffRate::Morocco results that match "horses"'
    end
  end
end
