require 'spec_helper'

describe 'Consolidated Envirotech API V1', type: :request do
  include_context 'all Envirotech fixture data'

  describe 'GET /envirotech/solutions/search.json' do
    let(:params) { { size: 100 } }
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
        let(:params) { { q: 'Precipitadores' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::Solution results that match "Precipitadores"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [Envirotech::Solution] }
        end
      end
    end

    context 'when source_ids are specified' do
      context 'when one document matches source_id 201' do
        let(:params) { { source_ids: 201 } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::Solution results that match source_id 201'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [Envirotech::Solution] }
        end
      end
    end
  end

  describe 'GET /envirotech/issues/search.json' do
    let(:params) { { size: 100 } }
    before { get '/envirotech/issues/search', params }
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
    end

    context 'when source_ids are specified' do
      context 'when one document matches source_id 23' do
        let(:params) { { source_ids: 23 } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::Issue results that match source_id 23'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [Envirotech::Issue] }
        end
      end
    end
  end

  describe 'GET /envirotech/regulations/search.json' do
    let(:params) { { size: 100 } }
    before { get '/envirotech/regulations/search', params }
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
    end

    context 'when source_ids are specified' do
      context 'when one document matches source_id 19' do
        let(:params) { { source_ids: 19 } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::Regulation results that match source_id 19'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [Envirotech::Regulation] }
        end
      end
    end
  end

  describe 'GET /envirotech/providers/search.json' do
    let(:params) { { size: 100 } }
    before { get '/envirotech/providers/search', params }
    subject { response }

    context 'when search parameters are empty' do
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all Envirotech::Provider results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) do
          [Envirotech::Provider]
        end
      end
    end

    context 'when q is specified' do
      context 'when one document matches "Corporation"' do
        let(:params) { { q: 'Corporation' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::Provider results that match "Corporation"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [Envirotech::Provider] }
        end
      end
    end

    context 'when source_ids are specified' do
      context 'when one document matches source_id 984' do
        let(:params) { { source_ids: 984 } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::Provider results that match source_id 984'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [Envirotech::Provider] }
        end
      end
    end
  end

  describe 'GET /envirotech/analysis_links/search.json' do
    let(:params) { { size: 100 } }
    before { get '/envirotech/analysis_links/search', params }
    subject { response }

    context 'when search parameters are empty' do
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all Envirotech::AnalysisLink results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) do
          [Envirotech::AnalysisLink]
        end
      end
    end

    context 'when q is specified' do
      context 'when one document matches "Metodos"' do
        let(:params) { { q: 'Metodos' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::AnalysisLink results that match "Metodos"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [Envirotech::AnalysisLink] }
        end
      end
    end

    context 'when source_ids are specified' do
      context 'when one document matches source_id 10' do
        let(:params) { { source_ids: 10 } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::AnalysisLink results that match source_id 10'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [Envirotech::AnalysisLink] }
        end
      end
    end

    context 'when issue_ids are specified' do
      context 'when one document matches issue_ids 19' do
        let(:params) { { issue_ids: 19 } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::AnalysisLink results that match issue_id 19'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [Envirotech::AnalysisLink] }
        end
      end
    end
  end

  describe 'GET /envirotech/background_links/search.json' do
    let(:params) { { size: 100 } }
    before { get '/envirotech/background_links/search', params }
    subject { response }

    context 'when search parameters are empty' do
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all Envirotech::BackgroundLink results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) do
          [Envirotech::BackgroundLink]
        end
      end
    end

    context 'when q is specified' do
      context 'when one document matches "Protecao"' do
        let(:params) { { q: 'Protecao' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::BackgroundLink results that match "Protecao"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [Envirotech::BackgroundLink] }
        end
      end
    end

    context 'when source_ids are specified' do
      context 'when one document matches source_id 1' do
        let(:params) { { source_ids: 1 } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::BackgroundLink results that match source_id 1'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [Envirotech::BackgroundLink] }
        end
      end
    end

    context 'when issue_ids are specified' do
      context 'when one document matches issue_ids 16' do
        let(:params) { { issue_ids: 16 } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::BackgroundLink results that match issue_id 16'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [Envirotech::BackgroundLink] }
        end
      end
    end
  end

  describe 'GET /envirotech/provider_solutions/search.json' do
    let(:params) { { size: 100 } }
    before { get '/envirotech/provider_solutions/search', params }
    subject { response }

    context 'when search parameters are empty' do
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all Envirotech::ProviderSolution results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) do
          [Envirotech::ProviderSolution]
        end
      end
    end

    context 'when source_ids are specified' do
      context 'when one document matches source_id 422' do
        let(:params) { { source_ids: 422 } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::ProviderSolution results that match source_id 422'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [Envirotech::ProviderSolution] }
        end
      end
    end

    context 'when solution_ids are specified' do
      context 'when one document matches solution_ids 196' do
        let(:params) { { solution_ids: 196 } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::ProviderSolution results that match solution_id 196'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [Envirotech::ProviderSolution] }
        end
      end
    end

    context 'when provider_ids are specified' do
      context 'when one document matches provider_ids 931' do
        let(:params) { { provider_ids: 931 } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::ProviderSolution results that match provider_id 931'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [Envirotech::ProviderSolution] }
        end
      end
    end

    context 'when provider_ids and solution_id are specified' do
      context 'when one document matches provider_ids 931' do
        let(:params) { { provider_ids: 931, solution_ids: 128 } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all Envirotech::ProviderSolution results that match provider_id 931 and solution_id 128'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [Envirotech::ProviderSolution] }
        end
      end
    end
  end
end
