require 'spec_helper'

describe 'Environmental Solutions API V2', type: :request do
  include_context 'V2 headers'

  before(:each) do
    fixtures_file =  "#{Rails.root}/spec/fixtures/environmental_solution_articles/environmental_solution_articles.json"
    EnvironmentalSolution.recreate_index
    allow_any_instance_of(EnvironmentalSolutionData).to receive(:fetch_data).and_return(JSON.parse File.open(fixtures_file).read)
    EnvironmentalSolutionData.new(fixtures_file).import
  end

  describe 'GET /environmental_solutions/search.json' do
    context 'when search parameters are empty' do
      let(:all_results) { JSON.parse Rails.root.join("#{File.dirname(__FILE__)}/environmental_solution/all_results.json").read }
      before { get '/environmental_solutions/search', {}, @v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns all results' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(2)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results).to match_array(all_results)
      end
    end
  end

  describe 'GET /environmental_solutions/search.json' do
    context 'when one document matches a query and filter' do
      let(:one_match) { JSON.parse Rails.root.join("#{File.dirname(__FILE__)}/environmental_solution/one_match.json").read }
      let(:params) { { q: 'Precipitadores' } }
      before { get '/environmental_solutions/search', params, @v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns the only result matching the query and filter' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results.first).to eq(one_match.first)
      end
      it_behaves_like "an empty result when a query doesn't match any documents"
    end

    context 'when stemming/folding matches a query' do
      let(:one_match) { JSON.parse Rails.root.join("#{File.dirname(__FILE__)}/environmental_solution/stemming_folding_match.json").read }
      let(:params) { { q: 'Eletrostaticos' } }
      before { get '/environmental_solutions/search', params }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns the result matching with stemming/folding' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results.first).to eq(one_match.first)
      end
    end

    context 'when stemming/folding matches a query with Chinese character' do
      let(:one_match) { JSON.parse Rails.root.join("#{File.dirname(__FILE__)}/environmental_solution/stemming_folding_match_chinese.json").read }
      let(:params) { { q: '高' } }
      before { get '/environmental_solutions/search', params }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns the result matching with stemming/folding' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results.first).to eq(one_match.first)
      end
    end
  end
end
