require 'spec_helper'

describe 'ECCN API V2', type: :request do
  include_context 'V2 headers'
  before(:all) do
    Eccn.recreate_index
    EccnData.new(
      "#{Rails.root}/spec/fixtures/eccns/eccns.csv").import
  end

  describe 'GET /eccns/search.json' do
    context 'when search parameters are empty' do
      let(:all_results) { JSON.parse Rails.root.join("#{File.dirname(__FILE__)}/eccns/all_results.json").read }
      before { get '/eccns/search', {}, @v2_headers }
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
      before { get '/eccns/search', params, @v2_headers }
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

  describe 'GET /eccns/search.json' do
    context 'when description match parameter given' do
      let(:params) { { description: 'forms' } }
      before { get '/eccns/search', params, @v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns matches for the description field' do
        results = JSON.parse(response.body)['results']
        expect(results.all? { |r| r['description'].match('forms') }).to be(true)
      end
    end
  end
end
