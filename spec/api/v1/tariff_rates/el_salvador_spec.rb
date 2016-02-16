require 'spec_helper'

describe 'FTA El Salvador Tariff Rates API V1', type: :request do
  include_context 'TariffRate::ElSalvador data'
  include_context 'exclude id from all possible full results'

  describe 'GET /v1/tariff_rates/search?sources=SV' do
    let(:params) { { sources: 'sv' } }
    before { get '/v1/tariff_rates/search', params }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'it contains all TariffRate::ElSalvador results'
      it_behaves_like 'a successful search request'
    end

    context 'when q is specified' do
      let(:params) { { sources: 'sv', q: 'horses' } }

      subject { response }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TariffRate::ElSalvador results that match "horses"'
      it_behaves_like "an empty result when a query doesn't match any documents", sources: 'sv'
    end
  end
end
