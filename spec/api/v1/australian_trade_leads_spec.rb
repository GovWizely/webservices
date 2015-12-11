require 'spec_helper'

describe 'Australian Trade Leads API V1', type: :request do
  before(:all) do
    TradeLead::Australia.recreate_index
    VCR.use_cassette('importers/trade_leads/australia.yml', record: :once) do
      TradeLead::AustraliaData.new(
        "#{Rails.root}/spec/fixtures/trade_leads/australia/trade_leads.csv").import
    end
  end

  let(:expected_results) { JSON.parse Rails.root.join("#{File.dirname(__FILE__)}/trade_leads/australia/results.json").read }

  describe 'GET /v1/australian_trade_leads/search' do
    context 'when search parameters are empty' do
      before { get '/v1/australian_trade_leads/search', {} }
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
      before { get '/v1/australian_trade_leads/search', params }
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
