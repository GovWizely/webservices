require 'spec_helper'

describe 'Market Researches API V2', type: :request do
  include_context 'MarketResearch data'

  let(:search_path) { '/market_research_library/search' }
  let(:v2_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v2' } }
  let(:expected_results) { JSON.parse open("#{Rails.root}/spec/fixtures/market_researches/results_v2.json").read }

  describe 'GET /market_research_library/search.json' do
    context 'when search parameters are empty' do
      before { get search_path, {}, v2_headers }
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

      context 'when q is specified' do
        let(:params) { { q: '2013' } }
        before { get search_path, params, v2_headers }
        subject { response }

        it_behaves_like 'a successful search request'

        it 'returns market researches' do
          json_response = JSON.parse(response.body)
          expect(json_response['total']).to eq(1)
          expect(json_response['offset']).to eq(0)

          results = json_response['results']
          expect(results[0]).to eq(expected_results[0])
        end
        it_behaves_like "an empty result when a query doesn't match any documents"
      end

      context 'when countries is specified' do
        let(:params) { { countries: 'ar,br' } }
        before { get search_path, params, v2_headers }
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
        it_behaves_like "an empty result when a countries search doesn't match any documents"
      end

      context 'when industries is specified' do
        context 'as single entry' do
          let(:params) { { industries: 'Aerospace & Defense' } }
          before { get search_path, params, v2_headers }
          subject { response }

          it_behaves_like 'a successful search request'

          it 'returns market researches' do
            json_response = JSON.parse(response.body)
            expect(json_response['total']).to eq(3)
            expect(json_response['offset']).to eq(0)

            results = json_response['results']
            expect(results[0]).to eq(expected_results[3])
            expect(results[1]).to eq(expected_results[4])
            expect(results[2]).to eq(expected_results[5])
          end
        end
        context 'as multiple entries' do
          let(:params) { { industries: 'Aerospace & Defense, Services' } }
          before { get search_path, params, v2_headers }
          subject { response }

          it_behaves_like 'a successful search request'

          it 'returns market researches' do
            json_response = JSON.parse(response.body)
            expect(json_response['total']).to eq(9)
            expect(json_response['offset']).to eq(0)

            results = json_response['results']
            expect(results[0]).to eq(expected_results[5])
          end
        end
        it_behaves_like "an empty result when an industries search doesn't match any documents"
      end

      context 'when searching for field with non ascii characters using ascii characters' do
        before { get search_path, { q: 'Developpement' }, v2_headers }
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
end
