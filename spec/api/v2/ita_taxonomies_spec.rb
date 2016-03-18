require 'spec_helper'

describe 'Ita Taxonomy API V2', type: :request do
  include_context 'V2 headers'

  before(:all) do
    ItaTaxonomy.recreate_index
    ItaTaxonomyData.new("#{Rails.root}/spec/fixtures/ita_taxonomies/test_data.zip").import
  end

  let(:search_path) { '/v2/ita_taxonomies/search' }
  let(:expected_results) { YAML.load_file("#{File.dirname(__FILE__)}/ita_taxonomies/results.yaml") }

  describe 'GET /ita_taxonomies/search.json' do
    context 'when search parameters are empty' do
      before { get search_path, { size: 50 }, @v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns ita taxonomies terms' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(9)
        results = json_response[:results]
        expect(results).to match_array expected_results
      end
    end

    context 'when q is specified' do
      let(:params) { { q: 'aviation' } }
      before { get search_path, params, @v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns ita taxonomies entries' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(1)

        results = json_response[:results]
        expect(results).to include(expected_results[2])
      end
      it_behaves_like "an empty result when a query doesn't match any documents"
    end

    context 'when query_expansion is specified' do
      let(:params) { { query_expansion: 'aviation Afghanistan united states' } }
      before { get search_path, params, @v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns ita taxonomies entries' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(2)

        results = json_response[:results]
        expect(results).to include(expected_results[1])
        expect(results).to include(expected_results[3])
      end
      it_behaves_like "an empty result when a query doesn't match any documents"
    end
  end
end
