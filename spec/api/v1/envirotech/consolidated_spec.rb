require 'spec_helper'

describe 'Consolidated Envirotech API V1', type: :request do
  include_context 'all Envirotech fixture data'

  describe 'GET /envirotech/search.json' do
    let(:params) { {size: 100} }
    before { get '/envirotech/solutions/search', params }
    subject { response }

    context 'when search parameters are empty' do
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all Envirotech::Solution results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) do
          [Envirotech::Solution]
        end
      end
    end

    context 'when q is specified' do
      context 'when one document matches "Precipitadores"' do
        let(:params) { {q: 'Precipitadores'} }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::Solution results that match "Precipitadores"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [Envirotech::Solution] }
        end
      end
    end
  end
end

