require 'spec_helper'

describe 'Consolidated Tariff Rates API V1' do
  include_context 'all Tariff Rates fixture data'
  let(:v1_headers) { {'Accept' => 'application/vnd.tradegov.webservices.v1'} }

  describe 'GET /consolidated_tariff_rate/search' do
    let(:params) { {size: 100} }
    before { get '/consolidated_tariff_rate/search', params, v1_headers }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'a successful search request'

      it_behaves_like 'it contains all TariffRate::Australia results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { %w(AUSTRALIA) }
      end
    end

    context 'when source is specified' do
      subject { response }

      let(:params) { {sources: 'AUSTRALIA'} }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TariffRate::Australia results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { %w(AUSTRALIA) }
      end
    end
  end
end
