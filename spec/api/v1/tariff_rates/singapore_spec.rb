require 'spec_helper'

describe 'FTA Singapore Tariff Rates API V1', type: :request do
  include_context 'TariffRate::Singapore data'

  describe 'GET /tariff_rates/search?sources=SG' do
    let(:params) { { sources: 'sg' } }
    before { get '/tariff_rates/search', params }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'it contains all TariffRate::Singapore results'
      it_behaves_like 'a successful search request'
    end

    context 'when q is specified' do
      let(:params) { { sources: 'sg', q: 'horses' } }

      subject { response }
      it_behaves_like 'a successful search request'
      it_behaves_like "an empty result when a query doesn't match any documents", sources: 'sg'
      it_behaves_like 'it contains all TariffRate::Singapore results that match "horses"'
    end
  end
end
