require 'spec_helper'

describe 'Market Researches API V1', type: :request do
  before(:all) do
    MarketResearch.recreate_index
    MarketResearchData.new("#{Rails.root}/spec/fixtures/market_researches/market_researches.txt").import
  end

  let(:search_path) { '/market_research_library/search' }
  let(:v1_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v1' } }
  let(:expected_results) { JSON.parse open("#{Rails.root}/spec/fixtures/market_researches/results.json").read }

  describe 'GET /market_research_library/search.json' do
    context 'when search parameters are empty' do
      before { get search_path, {}, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns market researches' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(6)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[0])
        expect(results[1]).to eq(expected_results[1])
        expect(results[2]).to eq(expected_results[2])
        expect(results[3]).to eq(expected_results[3])
        expect(results[4]).to eq(expected_results[4])
        expect(results[5]).to eq(expected_results[5])
      end
    end

    context 'when q is specified' do
      before { get search_path, { q: '2013' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns market researches' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[0])
      end
    end

    context 'when countries is specified' do
      before { get search_path, { countries: 'ar,br' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns market researches' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(2)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[2])
        expect(results[1]).to eq(expected_results[5])
      end
    end

    context 'when industry is specified' do
      before { get search_path, { industry: 'chemicals' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns market researches' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[5])
      end
    end

    context 'when searching for field with non ascii characters using ascii characters' do
      before { get search_path, { q: 'Developpement' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns market researches' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[4])
      end
    end
  end
end
