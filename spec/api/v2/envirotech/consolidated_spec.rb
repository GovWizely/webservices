# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'Consolidated Envirotech API V2', type: :request do
  include_context 'V2 headers'
  include_context 'all Envirotech fixture data'

  describe 'GET /v2/envirotech/solutions/search' do
    let(:params) { { size: 100 } }
    before { get '/v2/envirotech/solutions/search', params, @v2_headers }
    subject { response }

    context 'when search parameters are empty' do
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all Envirotech::Solution results'
    end

    context 'when q is specified' do
      context 'when one document matches "Precipitadores"' do
        let(:params) { { q: 'Precipitadores' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::Solution results that match "Precipitadores"'
      end

      context 'when stemming/folding matches a query' do
        let(:params) { { q: 'Eletrostaticos' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::Solution results matches a query with stemming/folding'
      end

      context 'when stemming/folding matches a query with Chinese character' do
        let(:params) { { q: '高' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::Solution results matches a query with Chinese character'
      end
    end

    context 'when size is -1' do
      let(:params) { { size: -1 } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all Envirotech::Solution results'

      it 'only contains solutions' do
        sources_used = JSON.parse(subject.body)['sources_used']
        expect(sources_used.count).to eq(1)
        expect(sources_used.first['source']).to eq('SOLUTIONS')
      end
    end
  end

  describe 'GET /v2/envirotech/issues/search' do
    let(:params) { { size: 100 } }
    before { get '/v2/envirotech/issues/search', params, @v2_headers }
    subject { response }

    context 'when search parameters are empty' do
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all Envirotech::Issue results'
    end

    context 'when q is specified' do
      context 'when one document matches "passivel"' do
        let(:params) { { q: 'passivel' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::Issue results that match "passivel"'
      end

      context 'when stemming/folding matches a query with Chinese character' do
        let(:params) { { q: '个' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::Issue results matches a query with Chinese character'
      end
    end

    context 'when regulation_ids are specified' do
      context 'when one document matches regulation_ids 19' do
        let(:params) { { regulation_ids: 19 } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::Issue results that match regulation_ids 19'
      end
    end
  end

  describe 'GET /v2/envirotech/regulations/search' do
    let(:params) { { size: 100 } }
    before { get '/v2/envirotech/regulations/search', params, @v2_headers }
    subject { response }

    context 'when search parameters are empty' do
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all Envirotech::Regulation results'
    end

    context 'when q is specified' do
      context 'when one document matches "dechets"' do
        let(:params) { { q: 'dechets' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::Regulation results that match "dechets"'
      end

      context 'when stemming/folding matches a query with Chinese character' do
        let(:params) { { q: '气' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::Regulation results matches a query with Chinese character'
      end
    end
  end

  describe 'GET /v2/envirotech/providers/search' do
    let(:params) { { size: 100 } }
    before { get '/v2/envirotech/providers/search', params, @v2_headers }
    subject { response }

    context 'when search parameters are empty' do
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all Envirotech::Provider results'
    end

    context 'when q is specified' do
      context 'when one document matches "Corporation"' do
        let(:params) { { q: 'Corporation' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::Provider results that match "Corporation"'
      end
    end
  end

  describe 'GET /v2/envirotech/analysis_links/search' do
    let(:params) { { size: 100 } }
    before { get '/v2/envirotech/analysis_links/search', params, @v2_headers }
    subject { response }

    context 'when search parameters are empty' do
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all Envirotech::AnalysisLink results'
    end

    context 'when q is specified' do
      context 'when one document matches "Metodos"' do
        let(:params) { { q: 'Metodos' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::AnalysisLink results that match "Metodos"'
      end
    end

    context 'when source_ids are specified' do
      context 'when one document matches source_id 10' do
        let(:params) { { source_ids: 10 } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::AnalysisLink results that match source_id 10'
      end
    end

    context 'when issue_ids are specified' do
      context 'when one document matches issue_ids 19' do
        let(:params) { { issue_ids: 19 } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::AnalysisLink results that match issue_id 19'
      end
    end
  end

  describe 'GET /v2/envirotech/background_links/search' do
    let(:params) { { size: 100 } }
    before { get '/v2/envirotech/background_links/search', params, @v2_headers }
    subject { response }

    context 'when search parameters are empty' do
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all Envirotech::BackgroundLink results'
    end

    context 'when q is specified' do
      context 'when one document matches "Protecao"' do
        let(:params) { { q: 'Protecao' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::BackgroundLink results that match "Protecao"'
      end
    end

    context 'when source_ids are specified' do
      context 'when one document matches source_id 10' do
        let(:params) { { source_ids: 1 } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::BackgroundLink results that match source_id 1'
      end
    end

    context 'when issue_ids are specified' do
      context 'when one document matches issue_ids 16' do
        let(:params) { { issue_ids: 16 } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::BackgroundLink results that match issue_id 16'
      end
    end
  end

  describe 'GET /v2/envirotech/provider_solutions/search' do
    let(:params) { { size: 100 } }
    before { get '/v2/envirotech/provider_solutions/search', params, @v2_headers }
    subject { response }

    context 'when search parameters are empty' do
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all Envirotech::ProviderSolution results'
    end

    context 'when source_ids are specified' do
      context 'when one document matches source_id 422' do
        let(:params) { { source_ids: 422 } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::ProviderSolution results that match source_id 422'
      end
    end

    context 'when solution_ids are specified' do
      context 'when one document matches solution_ids 201' do
        let(:params) { { solution_ids: 201 } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::ProviderSolution results that match solution_id 201'
      end
    end

    context 'when provider_ids are specified' do
      context 'when one document matches provider_ids 977' do
        let(:params) { { provider_ids: 977 } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::ProviderSolution results that match provider_id 977'
      end
    end

    context 'when provider_ids and solution_id are specified' do
      context 'when one document matches provider_ids 977' do
        let(:params) { { provider_ids: 977, solution_ids: 200 } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::ProviderSolution results that match provider_id 977 and solution_id 200'
      end
    end
  end

  describe 'GET /v2/envirotech/invalid_source/search' do
    let(:params) { { size: 100 } }

    context 'when :sources are invalid' do
      it { expect { get '/v2/envirotech/invalid_source/search', params }.to raise_error ActionController::RoutingError }
    end
  end
end
