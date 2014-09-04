require 'spec_helper'

describe 'Australian Trade Leads API V1' do
  before(:all) do
    AustralianTradeLead.recreate_index
    AustralianTradeLeadData.new("#{Rails.root}/spec/fixtures/australian_trade_leads/trade_leads.csv").import
  end

  let(:v1_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v1' } }
  let(:expected_results) { JSON.parse Rails.root.join('spec/fixtures/australian_trade_leads/results.json').read }

  describe 'GET /australian_trade_leads/search.json' do
    context 'when search parameters are empty' do
      before { get '/australian_trade_leads/search', {}, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns trade leads in arbitrary order' do
        json_response = JSON.parse(response.body)
        json_response['total'].should == 3
        json_response['offset'].should == 0

        results = json_response['results']
        results.should match_array(expected_results)
      end
    end
  end

  describe 'GET /australian_trade_leads/search.json' do
    context 'when q is populated' do
      before { get '/australian_trade_leads/search', { q: 'motor' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns trade leads ranked by relevance' do
        json_response = JSON.parse(response.body)
        json_response['total'].should == 1
        json_response['offset'].should == 0

        results = json_response['results']
        results[0].should == expected_results[1]
      end
    end
  end
end
