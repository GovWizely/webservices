require 'spec_helper'

describe 'FTA South Korea Tariff Rates API V1', type: :request do
  include_context 'TariffRate::SouthKorea data'

  describe 'GET /tariff_rates/search?sources=KR' do
    let(:params) { { sources: 'kr' } }
    before { get '/tariff_rates/search', params }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'it contains all TariffRate::SouthKorea results'
      it_behaves_like 'a successful search request'
    end

    context 'when q is specified' do
      let(:params) { { sources: 'kr', q: 'horses' } }

      subject { response }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TariffRate::SouthKorea results that match "horses"'
      it_behaves_like "an empty result when a query doesn't match any documents"
    end
  end
end
