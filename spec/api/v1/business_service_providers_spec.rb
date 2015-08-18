require 'spec_helper'

describe 'Business Service Providers API V1', type: :request do
  before(:all) do
    BusinessServiceProvider.recreate_index
    BusinessServiceProviderData.new(
      "#{Rails.root}/spec/fixtures/business_service_providers/articles.json").import
  end

  describe 'GET /v1/business_service_providers/search' do
    context 'when search parameters are empty' do
      let(:all_results) { JSON.parse Rails.root.join("#{File.dirname(__FILE__)}/business_service_providers/all_results.json").read }
      before { get '/v1/business_service_providers/search', {} }
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

  describe 'GET /business_service_providers/search.json' do
    context 'when one document matches a query and filter' do
      let(:one_match) { JSON.parse Rails.root.join("#{File.dirname(__FILE__)}/business_service_providers/one_match.json").read }
      let(:params) { { q: 'consult', ita_offices: 'el salvador' } }
      before { get '/v1/business_service_providers/search', params }
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
