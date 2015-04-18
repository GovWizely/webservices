require 'spec_helper'

describe 'Australian Trade Leads API V1', type: :request do

  before(:all) do
    TradeLead::Australia.recreate_index
    TradeLead::AustraliaData.new(
        "#{Rails.root}/spec/fixtures/trade_leads/australia/trade_leads.csv").import
  end

  let(:expected_results) { JSON.parse Rails.root.join("#{File.dirname(__FILE__)}/trade_leads/australia/results.json").read }
  let(:v1_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v1' } }

  describe 'GET /australian_trade_leads/search.json' do
    context 'when search parameters are empty' do
      before { get '/australian_trade_leads/search', {}, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns trade leads in arbitrary order' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(3)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results).to match_array(expected_results)
      end
    end
  end

  describe 'GET /australian_trade_leads/search.json' do
    context 'when q is populated' do
      let(:params) { { q: 'motor' } }
      before { get '/australian_trade_leads/search', params, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns trade leads ranked by relevance' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[1])
      end
      it_behaves_like "an empty result when a query doesn't match any documents"
    end
  end
end
