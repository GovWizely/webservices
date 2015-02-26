require 'spec_helper'

describe 'Trade Leads API V1', type: :request do
  before(:all) do
    TradeLead::Australia.recreate_index
    TradeLead::Canada.recreate_index
    TradeLead::Fbopen.recreate_index
    TradeLead::State.recreate_index
    TradeLead::Uk.recreate_index
    TradeLead::FbopenData.new("#{Rails.root}/spec/fixtures/trade_leads/fbopen/input_presol").import('no_purge')
    TradeLead::CanadaData.new("#{Rails.root}/spec/fixtures/trade_leads/canada/canada_leads.csv").import
    TradeLead::UkData.new("#{Rails.root}/spec/fixtures/trade_leads/uk/uk_trade_leads.csv").import
    TradeLead::StateData.new("#{Rails.root}/spec/fixtures/trade_leads/state/state_trade_leads.json").import
  end

  let(:v1_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v1' } }
  let(:expected_results) { JSON.parse Rails.root.join('spec/fixtures/trade_leads/expected_results_v1.json').read }

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
        expect(results).to match_array(expected_results.first(10))
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
      let(:params) { { countries: 'GB' } }
      before { get '/trade_leads/search', params, v1_headers }
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
      it_behaves_like "an empty result when a countries search doesn't match any documents"
    end

    context 'when q matches a title' do
      let(:params) { { q: 'physician service' } }
      before { get '/trade_leads/search', params, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns relevant trade leads' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[0])
      end
      it_behaves_like "an empty result when a query doesn't match any documents"
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
