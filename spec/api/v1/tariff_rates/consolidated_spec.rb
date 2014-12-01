require 'spec_helper'

describe 'Consolidated Tariff Rates API V1', type: :request do
  include_context 'all Tariff Rates fixture data'
  let(:v1_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v1' } }

  describe 'GET /tariff_rates/search' do
    let(:params) { { size: 100 } }
    before { get '/tariff_rates/search', params, v1_headers }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'a successful search request'

      it_behaves_like 'it contains all TariffRate::Australia results'
      it_behaves_like 'it contains all TariffRate::CostaRica results'
      it_behaves_like 'it contains all TariffRate::ElSalvador results'
      it_behaves_like 'it contains all TariffRate::Guatemala results'
      it_behaves_like 'it contains all TariffRate::SouthKorea results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) do
          [TariffRate::Australia, TariffRate::CostaRica, TariffRate::ElSalvador,
           TariffRate::Guatemala, TariffRate::SouthKorea]
        end
      end
    end

    context 'when source is specified' do
      subject { response }

      let(:params) { { sources: 'AUSTRALIA' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TariffRate::Australia results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TariffRate::Australia] }
      end
    end

    context 'and is set to "COSTARICA" source' do
      let(:params) { { sources: 'COSTA_RICA' } }
      it_behaves_like 'it contains all TariffRate::CostaRica results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TariffRate::CostaRica] }
      end
    end

    context 'and is set to "EL_SALVADOR" source' do
      let(:params) { { sources: 'EL_SALVADOR' } }
      it_behaves_like 'it contains all TariffRate::ElSalvador results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TariffRate::ElSalvador] }
      end
    end

    context 'and is set to "GUATEMALA" source' do
      let(:params) { { sources: 'GUATEMALA' } }
      it_behaves_like 'it contains all TariffRate::Guatemala results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TariffRate::Guatemala] }
      end
    end

    context 'and is set to "SOUTH_KOREA" source' do
      let(:params) { { sources: 'SOUTH_KOREA' } }
      it_behaves_like 'it contains all TariffRate::SouthKorea results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TariffRate::SouthKorea] }
      end
    end
  end
end
