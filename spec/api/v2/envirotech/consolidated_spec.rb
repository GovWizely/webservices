require 'spec_helper'

describe 'Consolidated Envirotech API V2', type: :request do
  include_context 'V2 headers'
  include_context 'all Envirotech v2 fixture data'

  describe 'GET /v2/envirotech/solutions/search.json' do
    let(:params) { { size: 100 } }
    before { get '/v2/envirotech/solutions/search', params }
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
        let(:params) { { q: 'Precipitadores' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::Solution results that match "Precipitadores"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [Envirotech::Solution] }
        end
      end

      context 'when stemming/folding matches a query' do
        let(:params) { { q: 'Eletrostaticos' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::Solution results matches a query with stemming/folding'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [Envirotech::Solution] }
        end
      end

      context 'when stemming/folding matches a query with Chinese character' do
        let(:params) { { q: '高' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::Solution results matches a query with Chinese character'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [Envirotech::Solution] }
        end
      end
    end
  end

  describe 'GET /v2/envirotech/issues/search.json' do
    let(:params) { { size: 100 } }
    before { get '/v2/envirotech/issues/search', params }
    subject { response }

    context 'when search parameters are empty' do
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all Envirotech::Issue results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) do
          [Envirotech::Issue]
        end
      end
    end

    context 'when q is specified' do
      context 'when one document matches "passivel"' do
        let(:params) { { q: 'passivel' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::Issue results that match "passivel"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [Envirotech::Issue] }
        end
      end

      context 'when stemming/folding matches a query with Chinese character' do
        let(:params) { { q: '个' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::Issue results matches a query with Chinese character'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [Envirotech::Issue] }
        end
      end
    end
  end

  describe 'GET /v2/envirotech/regulations/search.json' do
    let(:params) { { size: 100 } }
    before { get '/v2/envirotech/regulations/search', params }
    subject { response }

    context 'when search parameters are empty' do
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all Envirotech::Regulation results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) do
          [Envirotech::Regulation]
        end
      end
    end

    context 'when q is specified' do
      context 'when one document matches "dechets"' do
        let(:params) { { q: 'dechets' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::Regulation results that match "dechets"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [Envirotech::Regulation] }
        end
      end

      context 'when stemming/folding matches a query with Chinese character' do
        let(:params) { { q: '气' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::Regulation results matches a query with Chinese character'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [Envirotech::Regulation] }
        end
      end
    end
  end
end
