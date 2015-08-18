require 'spec_helper'

describe 'UK Trade Leads API V1', type: :request do
  before(:all) do
    TradeLead::Uk.recreate_index
    TradeLead::UkData.new(
      "#{Rails.root}/spec/fixtures/trade_leads/uk/Notices.xml").import
  end
  let(:expected_results) do
    JSON.parse(open("#{File.dirname(__FILE__)}/trade_leads/uk/results.json").read,
               symbolize_names: true)
  end

  describe 'GET /v1/uk_trade_leads/search' do
    let(:params) { {} }
    before { get '/v1/uk_trade_leads/search', params }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'a successful search request'

      it 'returns all documents' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(9)
        results = json_response[:results]
        expect(results).to match_array(expected_results)
      end
    end
  end
end
