require 'spec_helper'

describe 'Ita Zip Code API V2', type: :request do
  include_context 'V2 headers'

  before(:all) do
    ItaZipCode.recreate_index
    ItaZipCodeData.new("#{Rails.root}/spec/fixtures/ita_zip_codes/posts.xml",
                       "#{Rails.root}/spec/fixtures/ita_zip_codes/zip_codes.xml").import
  end

  let(:search_path) { '/v2/ita_zipcode_to_post/search' }
  let(:expected_results) { YAML.load_file("#{File.dirname(__FILE__)}/ita_zip_codes/results.yaml") }

  describe 'GET /ita_zipcode_to_post/search.json' do
    context 'when search parameters are empty' do
      before { get search_path, { size: 50 }, @v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns zip code entries' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(2)

        results = json_response[:results]
        expect(results).to match_array expected_results
      end
    end

    context 'when q is specified' do
      let(:params) { { q: 'long island' } }
      before { get search_path, params, @v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns zip code entries' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(2)

        results = json_response[:results]
        expect(results).to match_array expected_results
      end
      it_behaves_like "an empty result when a query doesn't match any documents"
    end

    context 'when one zip code is specified' do
      before { get search_path, { zip_codes: '00501' }, @v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns zip code entries' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(1)

        results = json_response[:results]
        expect(results).to include expected_results[0]
      end
    end

    context 'when multiple zip codes are specified' do
      before { get search_path, { zip_codes: '00501,00544' }, @v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns zip code entries' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(2)

        results = json_response[:results]
        expect(results).to include expected_results[0]
        expect(results).to include expected_results[1]
      end
    end
  end
end
