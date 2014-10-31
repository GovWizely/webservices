require 'spec_helper'

describe 'Trade Leads API V1', type: :request do
  before(:all) do
    CanadaLead.recreate_index
    CanadaLeadData.new("#{Rails.root}/spec/fixtures/canada_leads/canada_leads.csv").import

    StateTradeLead.recreate_index
    StateTradeLeadData.new("#{Rails.root}/spec/fixtures/state_trade_leads/state_trade_leads.json").import

    UkTradeLead.recreate_index
    UkTradeLeadData.new("#{Rails.root}/spec/fixtures/uk_trade_leads/uk_trade_leads.csv").import

    FbopenLead.recreate_index
    FbopenLeadData.new("#{Rails.root}/spec/fixtures/fbopen_leads/input_presol").import
  end

  let(:v1_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v1' } }
  let(:expected_results) { JSON.parse Rails.root.join('spec/fixtures/trade_leads/expected_results.json').read }

  describe 'GET /trade_leads/search.json' do
    context 'when search parameters are empty' do
      before { get '/trade_leads/search', {}, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns trade leads sorted by published_date:desc, country: asc' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(13)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results).to eq(expected_results.first(10))
      end
    end

    context 'when size is specified' do
      before { get '/trade_leads/search', { size: 100 }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns up to the specified size' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(13)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results).to match_array(expected_results)
      end
    end

    context 'when countries is populated' do
      before { get '/trade_leads/search', { countries: 'GB' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns trade leads sorted by id in descending order' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(3)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[1])
        expect(results[1]).to eq(expected_results[2])
        expect(results[2]).to eq(expected_results[3])
      end
    end

    context 'when q matches a title' do
      before { get '/trade_leads/search', { q: 'physician service' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns relevant trade leads' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[0])
      end
    end

    context 'when q matches a description' do
      before { get '/trade_leads/search', { q: 'ambulatory' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns relevant trade leads' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[7])
      end
    end
  end
end
