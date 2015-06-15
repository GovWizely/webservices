require 'spec_helper'

describe 'ECCN API V1', type: :request do
  before(:all) do
    Eccn.recreate_index
    EccnData.new(
      "#{Rails.root}/spec/fixtures/eccns/eccns.csv").import
  end

  describe 'GET /eccns/search.json' do
    context 'when search parameters are empty' do
      let(:all_results) { JSON.parse Rails.root.join("#{File.dirname(__FILE__)}/eccns/all_results.json").read }
      before { get '/eccns/search', {} }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns all results' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(6)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results).to match_array(all_results['results'])
      end
    end
  end

  describe 'GET /eccns/search.json' do
    context 'when one document matches a query' do
      let(:one_match) { JSON.parse Rails.root.join("#{File.dirname(__FILE__)}/eccns/one_match.json").read }
      let(:params) { { q: 'planar absorbers' } }
      before { get '/eccns/search', params }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns the only result matching the query' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results).to match_array(one_match['results'])
      end
      it_behaves_like "an empty result when a query doesn't match any documents"
    end
  end
end
