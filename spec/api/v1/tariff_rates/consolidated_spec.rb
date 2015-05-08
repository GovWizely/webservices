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
      it_behaves_like 'it contains all TariffRate::Bahrain results'
      it_behaves_like 'it contains all TariffRate::Chile results'
      it_behaves_like 'it contains all TariffRate::Colombia results'
      it_behaves_like 'it contains all TariffRate::CostaRica results'
      it_behaves_like 'it contains all TariffRate::DominicanRepublic results'
      it_behaves_like 'it contains all TariffRate::ElSalvador results'
      it_behaves_like 'it contains all TariffRate::Guatemala results'
      it_behaves_like 'it contains all TariffRate::Honduras results'
      it_behaves_like 'it contains all TariffRate::Morocco results'
      it_behaves_like 'it contains all TariffRate::Nicaragua results'
      it_behaves_like 'it contains all TariffRate::Oman results'
      it_behaves_like 'it contains all TariffRate::Panama results'
      it_behaves_like 'it contains all TariffRate::Peru results'
      it_behaves_like 'it contains all TariffRate::Singapore results'
      it_behaves_like 'it contains all TariffRate::SouthKorea results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) do
          [TariffRate::Australia, TariffRate::Bahrain, TariffRate::Chile, TariffRate::Colombia,
           TariffRate::CostaRica, TariffRate::DominicanRepublic, TariffRate::ElSalvador,
           TariffRate::Guatemala, TariffRate::Honduras, TariffRate::Morocco, TariffRate::Nicaragua,
           TariffRate::Oman, TariffRate::Panama, TariffRate::Peru, TariffRate::Singapore,
           TariffRate::SouthKorea]
        end
      end
    end

    context 'when source is specified' do
      subject { response }

      let(:params) { { sources: 'AU' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TariffRate::Australia results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TariffRate::Australia] }
      end
    end

    context 'and is set to "BAHRAIN" source' do
      let(:params) { { sources: 'BH' } }
      it_behaves_like 'it contains all TariffRate::Bahrain results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TariffRate::Bahrain] }
      end
    end

    context 'and is set to "CHILE" source' do
      let(:params) { { sources: 'CL' } }
      it_behaves_like 'it contains all TariffRate::Chile results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TariffRate::Chile] }
      end
    end

    context 'and is set to "COLOMBIA" source' do
      let(:params) { { sources: 'CO' } }
      it_behaves_like 'it contains all TariffRate::Colombia results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TariffRate::Colombia] }
      end
    end

    context 'and is set to "COSTARICA" source' do
      let(:params) { { sources: 'CR' } }
      it_behaves_like 'it contains all TariffRate::CostaRica results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TariffRate::CostaRica] }
      end
    end

    context 'and is set to "DOMINICAN_REPUBLIC" source' do
      let(:params) { { sources: 'DO' } }
      it_behaves_like 'it contains all TariffRate::DominicanRepublic results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TariffRate::DominicanRepublic] }
      end
    end

    context 'and is set to "EL_SALVADOR" source' do
      let(:params) { { sources: 'SV' } }
      it_behaves_like 'it contains all TariffRate::ElSalvador results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TariffRate::ElSalvador] }
      end
    end

    context 'and is set to "GUATEMALA" source' do
      let(:params) { { sources: 'GT' } }
      it_behaves_like 'it contains all TariffRate::Guatemala results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TariffRate::Guatemala] }
      end
    end

    context 'and is set to "HONDURAS" source' do
      let(:params) { { sources: 'HN' } }
      it_behaves_like 'it contains all TariffRate::Honduras results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TariffRate::Honduras] }
      end
    end

    context 'and is set to "MOROCCO" source' do
      let(:params) { { sources: 'MA' } }
      it_behaves_like 'it contains all TariffRate::Morocco results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TariffRate::Morocco] }
      end
    end

    context 'and is set to "NICARAGUA" source' do
      let(:params) { { sources: 'NI' } }
      it_behaves_like 'it contains all TariffRate::Nicaragua results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TariffRate::Nicaragua] }
      end
    end

    context 'and is set to "OMAN" source' do
      let(:params) { { sources: 'OM' } }
      it_behaves_like 'it contains all TariffRate::Oman results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TariffRate::Oman] }
      end
    end

    context 'and is set to "PANAMA" source' do
      let(:params) { { sources: 'PA' } }
      it_behaves_like 'it contains all TariffRate::Panama results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TariffRate::Panama] }
      end
    end

    context 'and is set to "PERU" source' do
      let(:params) { { sources: 'PE' } }
      it_behaves_like 'it contains all TariffRate::Peru results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TariffRate::Peru] }
      end
    end

    context 'and is set to "SINGAPORE" source' do
      let(:params) { { sources: 'SG' } }
      it_behaves_like 'it contains all TariffRate::Singapore results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TariffRate::Singapore] }
      end
    end

    context 'and is set to "SOUTH_KOREA" source' do
      let(:params) { { sources: 'KR' } }
      it_behaves_like 'it contains all TariffRate::SouthKorea results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TariffRate::SouthKorea] }
      end
    end
  end
end
