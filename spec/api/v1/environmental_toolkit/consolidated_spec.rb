require 'spec_helper'

describe 'Consolidated Environmental Toolkit API V1', type: :request do
  include_context 'all Environmental Toolkit fixture data'

  describe 'GET /environmental_toolkit/search.json' do
    let(:params) { {size: 100} }
    before { get '/environmental_toolkit/search', params }
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
        let(:params) { {q: 'Precipitadores'} }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all EnvironmentalToolkit::EnvironmentalSolution results that match "Precipitadores"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [EnvironmentalToolkit::EnvironmentalSolution] }
        end
      end
    end
  end
end

