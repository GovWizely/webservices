require 'spec_helper'

describe 'Consolidated Environmental Toolkit API V2', type: :request do
  include_context 'V2 headers'
  include_context 'all Environmental Toolkit v2 fixture data'

  describe 'GET /v2/environmental_toolkit/search.json' do
    let(:params) { { size: 100 } }
    before { get '/v2/environmental_toolkit/search', params }
    subject { response }

    context 'when search parameters are empty' do
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all EnvironmentalToolkit::EnvironmentalSolution results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) do
          [EnvironmentalToolkit::EnvironmentalSolution]
        end
      end
    end

    context 'when q is specified' do
      context 'when one document matches "Precipitadores"' do
        let(:params) { { q: 'Precipitadores' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all EnvironmentalToolkit::EnvironmentalSolution results that match "Precipitadores"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [EnvironmentalToolkit::EnvironmentalSolution] }
        end
      end

      context 'when stemming/folding matches a query' do
        let(:params) { { q: 'Eletrostaticos' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all EnvironmentalToolkit::EnvironmentalSolution results matches a query with stemming/folding'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [EnvironmentalToolkit::EnvironmentalSolution] }
        end
      end

      context 'when stemming/folding matches a query with Chinese character' do
        let(:params) { { q: '高' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all EnvironmentalToolkit::EnvironmentalSolution results matches a query with Chinese character'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [EnvironmentalToolkit::EnvironmentalSolution] }
        end
      end
    end
  end
end
