require 'spec_helper'

describe 'Country Fact Sheets API V2', type: :request do
  include_context 'V2 headers'

  before(:all) do
    CountryFactSheet.recreate_index
    CountryFactSheetData.new(
      "#{Rails.root}/spec/fixtures/country_fact_sheets/country_fact_sheets.json").import
  end

  let(:search_path) { '/v2/country_fact_sheets/search' }
  let(:params) { { size: 100 } }
  let(:expected_results) { YAML.load_file("#{File.dirname(__FILE__)}/country_fact_sheets/results.yaml") }

  describe 'GET /country_fact_sheets/search.json' do
    before { get search_path, params, @v2_headers }
    subject { response }

    context 'when search parameters are empty' do
      it_behaves_like 'a successful search request'

      it 'return country fact sheets' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq 2
        results = json_response[:results]
        expect(results).to match_array expected_results
      end
    end

    context 'when q is specified' do
      let(:params) { { q: 'Albania' } }

      it_behaves_like 'a successful search request'

      it 'return matching country fact sheets entries' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq 1
        results = json_response[:results]
        expect(results[0]).to eq expected_results[1]
      end
    end

    context 'when country is specified' do
      let(:params) { { countries: 'AF' } }

      it_behaves_like 'a successful search request'

      it 'return matching country fact sheets entries' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq 1
        results = json_response[:results]
        expect(results[0]).to eq expected_results[0]
      end
    end

    context 'when multiple countries are specified' do
      let(:params) { { countries: 'AF,AL' } }

      it_behaves_like 'a successful search request'

      it 'return matching country fact sheets entries' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq 2
        results = json_response[:results]
        expect(results).to eq expected_results
      end
    end
  end
end
