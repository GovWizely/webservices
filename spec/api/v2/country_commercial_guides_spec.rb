require 'spec_helper'

describe 'Country Commercial Guide API V2', type: :request do
  before(:all) do
    CountryCommercialGuide.recreate_index
    CountryCommercialGuideData.new("#{Rails.root}/spec/fixtures/country_commercial_guides/yaml/*").import
  end

  let(:search_path) { '/country_commercial_guides/search' }
  let(:v2_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v2' } }
  let(:expected_results) { YAML.load_file("#{Rails.root}/spec/fixtures/country_commercial_guides/results_with_content.yaml") }

  describe 'GET /country_commercial_guides/search.json' do

    context 'when search parameters are empty' do
      before { get search_path, { size: 50 }, v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns country commercial guide sections' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(23)

        results = json_response[:results]
        expect(results).to match_array expected_results

      end
    end

    context 'when q is specified' do
      let(:params) { { q: 'franchising' } }
      before { get search_path, params, v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns country commercial guide sections' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(3)

        results = json_response[:results]
        expect(results[0]).to eq(expected_results[8])

      end
    end

    context 'when q is specified' do
      let(:params) { { q: 'franchising' } }
      before { get search_path, params, v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns country commercial guide sections' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(3)

        results = json_response[:results]
        expect(results[0]).to eq(expected_results[8])
        expect(results[1]).to eq(expected_results[2])
        expect(results[2]).to eq(expected_results[0])
      end
    end

    context 'when countries and topics are specified' do
      let(:params) { { countries: 'co', topics: 'automotive' } }
      before { get search_path, params, v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns country commercial guide sections' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(1)

        results = json_response[:results]
        expect(results[0]).to eq(expected_results[3])
      end
    end

  end

end
