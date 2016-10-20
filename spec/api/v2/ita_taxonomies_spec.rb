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
        expect(json_response[:total]).to eq(20)
        results = json_response[:results]
        expect(results).to match_array expected_results
      end
    end

    context 'when q is specified' do
      let(:params) { { q: 'cote' } }
      before { get search_path, params, @v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns ita taxonomies entries' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(1)

        results = json_response[:results]
        expect(results).to include(expected_results[7])
      end
      it_behaves_like "an empty result when a query doesn't match any documents"
    end

    context 'when labels is specified' do
      let(:params) { { labels: 'China, North America' } }
      before { get search_path, params, @v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns ita taxonomies entries' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(2)

        results = json_response[:results]
        expect(results).to include(expected_results[6])
        expect(results).to include(expected_results[13])
      end
      it_behaves_like "an empty result when a query doesn't match any documents"
    end
  end

  describe 'GET /ita_taxonomies/:id' do
    context 'when trying to retrieve an ITA Taxonomy entry using a valid id' do
      let(:expected_result) { expected_results.first }
      let(:id) { expected_result[:id] }

      before { get "/v2/ita_taxonomies/#{id}", nil, @v2_headers }

      subject { response }

      include_examples 'a successful get by id response', source: ItaTaxonomy
    end

    it_behaves_like 'a get by id endpoint with not found response', resource_name: 'ita_taxonomies'
  end

  describe 'GET /ita_taxonomies/query_expansion' do
    context 'when trying to retrieve query expansion terms for a query' do
      let(:expected_results) { JSON.parse open("#{File.dirname(__FILE__)}/ita_taxonomies/query_expansion_results.json").read }
      let(:params) { { q: 'healthcare China United States' } }

      before { get '/v2/ita_taxonomies/query_expansion', params, @v2_headers }
      subject { response }

      it 'returns the correct terms' do
        json_response = JSON.parse(response.body)
        expect(json_response).to eq(expected_results)
      end
    end

    context 'when the query contains no controlled terms' do
      let(:expected_results) { JSON.parse open("#{File.dirname(__FILE__)}/ita_taxonomies/query_expansion_empty_results.json").read }
      let(:params) { { q: 'elephants' } }

      before { get '/v2/ita_taxonomies/query_expansion', params, @v2_headers }
      subject { response }

      it 'returns an empty response' do
        json_response = JSON.parse(response.body)
        expect(json_response).to eq(expected_results)
      end
    end

    context 'when trying to retrieve query_expansion terms for a query with punctuation' do
      let(:expected_results) { JSON.parse open("#{File.dirname(__FILE__)}/ita_taxonomies/query_expansion_results.json").read }
      let(:params) { { q: 'healthcare united states, china.' } }

      before { get '/v2/ita_taxonomies/query_expansion', params, @v2_headers }
      subject { response }

      it 'returns the correct terms' do
        json_response = JSON.parse(response.body)
        expect(json_response).to eq(expected_results)
      end
    end

    context 'when q is not specified as a parameter' do
      let(:params) { {} }
      before { get '/v2/ita_taxonomies/query_expansion', params, @v2_headers }
      subject { response }

      it 'responds with an error message and 400 status' do
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)).to eq('error'=> 'param is missing or the value is empty: q')
      end
    end
  end

  describe 'GET /ita_taxonomies/suggest' do
    let(:suggest_path) { '/ita_taxonomies/suggest' }

    context 'when term is specified' do
      let(:params) { { term: 'asia', size: '1' } }
      before { get suggest_path, params, @v2_headers }
      subject { response }

      it { is_expected.to have_attributes(status: 200) }

      it 'returns suggestions' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response).to eq(['Asia'])
      end
    end

    context 'when term is too short' do
      let(:params) { { term: ' a ' } }
      before { get suggest_path, params, @v2_headers }
      subject { response }

      it { is_expected.to have_attributes(status: 400) }

      it 'returns error message' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:error]).to eq('`term` parameter is required and it must be at least 2 characters long')
      end
    end

    context 'when term is not specified' do
      let(:params) { {} }
      before { get suggest_path, params, @v2_headers }
      subject { response }

      it { is_expected.to have_attributes(status: 400) }

      it 'returns error message' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:error]).to eq('`term` parameter is required and it must be at least 2 characters long')
      end
    end
  end
end
