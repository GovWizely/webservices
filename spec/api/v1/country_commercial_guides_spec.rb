require 'spec_helper'

describe 'Country Commercial Guide API V1', type: :request do
  before(:all) do
    CountryCommercialGuide.recreate_index
    CountryCommercialGuideData.new("#{Rails.root}/spec/fixtures/country_commercial_guides/yaml/*").import
  end

  let(:search_path) { '/country_commercial_guides/search' }
  let(:v1_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v1' } }
  let(:expected_results) { YAML.load_file("#{Rails.root}/spec/fixtures/country_commercial_guides/results.yaml") }

  describe 'GET /country_commercial_guides/search.json' do

    context 'when search parameters are empty' do
      before { get search_path, { size: 50 }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns country commercial guide sections' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(6)

        results = json_response[:results]
        expect(results).to match_array expected_results

      end
    end

    context 'when q is specified' do
      let(:params) { { q: 'defense' } }
      before { get search_path, params, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns country commercial guide sections' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(3)

        results = json_response[:results]
        expect(results[0].include?(expected_results[4]))
        expect(results[1].include?(expected_results[5]))
        expect(results[2].include?(expected_results[0]))
      end
    end

    context 'when countries is specified' do
      let(:params) { { countries: 'co' } }
      before { get search_path, params, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns country commercial guide sections' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(6)

        results = json_response[:results]
        expect(results).to match_array expected_results

      end
    end

    context 'when topics is specified' do
      let(:params) { { topics: 'automotive - overview' } }
      before { get search_path, params, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns country commercial guide sections' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(1)

        results = json_response[:results]
        expect(results.include?(expected_results[0]))
      end
    end

    context 'when industries is specified' do
      let(:params) { { industries: 'defense' } }
      before { get search_path, params, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns country commercial guide sections' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(2)

        results = json_response[:results]
        expect(results.include?(expected_results[4]))
        expect(results.include?(expected_results[5]))

      end
    end

  end

end
