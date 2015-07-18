require 'spec_helper'

describe 'FTA DominicanRepublic Tariff Rates API V1', type: :request do
  include_context 'TariffRate::DominicanRepublic data'

  describe 'GET /tariff_rates/search?sources=DO' do
    let(:params) { { sources: 'do' } }
    before { get '/tariff_rates/search', params }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'it contains all TariffRate::DominicanRepublic results'
      it_behaves_like 'a successful search request'
    end

    context 'when q is specified' do
      let(:params) { { sources: 'do', q: 'horses' } }

      subject { response }
      it_behaves_like 'a successful search request'
      it_behaves_like "an empty result when a query doesn't match any documents", sources: 'do'
      it_behaves_like 'it contains all TariffRate::DominicanRepublic results that match "horses"'
    end
  end
end
