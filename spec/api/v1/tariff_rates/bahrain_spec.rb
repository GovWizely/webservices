require 'spec_helper'

describe 'FTA Bahrain Tariff Rates API V1', type: :request do
  include_context 'TariffRate::Bahrain data'
  include_context 'exclude id from all possible full results'

  describe 'GET /v1/tariff_rates/search?sources=BH' do
    let(:params) { { sources: 'bh' } }
    before { get '/v1/tariff_rates/search', params }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'it contains all TariffRate::Bahrain results'
      it_behaves_like 'a successful search request'
    end

    context 'when q is specified' do
      let(:params) { { sources: 'bh', q: 'horses' } }

      subject { response }
      it_behaves_like 'a successful search request'
      it_behaves_like "an empty result when a query doesn't match any documents", sources: 'bh'
      it_behaves_like 'it contains all TariffRate::Bahrain results that match "horses"'
    end
  end
end
