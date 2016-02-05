require 'spec_helper'

describe 'FTA Guatemala Tariff Rates API V1', type: :request do
  include_context 'TariffRate::Guatemala data'
  include_context 'exclude id from all possible full results'

  describe 'GET /v1/tariff_rates/search?sources=GT' do
    let(:params) { { sources: 'gt' } }
    before { get '/v1/tariff_rates/search', params }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'it contains all TariffRate::Guatemala results'
      it_behaves_like 'a successful search request'
    end

    context 'when q is specified' do
      let(:params) { { sources: 'gt', q: 'horses' } }

      subject { response }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TariffRate::Guatemala results that match "horses"'
      it_behaves_like "an empty result when a query doesn't match any documents", sources: 'gt'
    end
  end
end
