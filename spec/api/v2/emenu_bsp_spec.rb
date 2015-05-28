require 'spec_helper'

describe 'Emenu BSP API V2', type: :request do
  include_context 'V2 headers'
  before(:all) do
    EmenuBsp.recreate_index
    EmenuBspData.new(
      "#{Rails.root}/spec/fixtures/emenu_bsp_articles/emenu_bsp_articles.json").import
  end

  describe 'GET /emenu_bsps/search.json' do
    context 'when search parameters are empty' do
      let(:all_results) { JSON.parse Rails.root.join("#{File.dirname(__FILE__)}/emenu_bsps/all_results.json").read }
      before { get '/emenu_bsps/search', {}, @v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns all results' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(3)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results).to match_array(all_results)
      end
    end
  end

  describe 'GET /emenu_bsps/search.json' do
    context 'when one document matches a query and filter' do
      let(:one_match) { JSON.parse Rails.root.join("#{File.dirname(__FILE__)}/emenu_bsps/one_match.json").read }
      let(:params) { { q: 'consult', ita_offices: 'el salvador' } }
      before { get '/emenu_bsps/search', params, @v2_headers }
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
  end
end
