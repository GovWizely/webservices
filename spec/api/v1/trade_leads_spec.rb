require 'spec_helper'

describe 'Trade Leads API V1', type: :request do
  before(:all) do

    TradeLead::Australia.recreate_index
    TradeLead::Canada.recreate_index
    TradeLead::Fbopen.recreate_index
    TradeLead::State.recreate_index
    TradeLead::Uk.recreate_index

    VCR.use_cassette("TradeLead_FbopenData/_leads/correctly_transform_leads_from_dump", :record => :new_episodes) do
      TradeLead::FbopenData.new("#{Rails.root}/spec/fixtures/trade_leads/fbopen/input_presol").import
    end

    VCR.use_cassette("TradeLead_CanadaData/_leads/correctly_transform_leads_from_csv", :record => :new_episodes) do
      TradeLead::CanadaData.new("#{Rails.root}/spec/fixtures/trade_leads/canada/canada_leads.csv").import
    end
    
    VCR.use_cassette("TradeLead_UkData/_import/loads_UK_trade_leads_from_specified_resource", :record => :new_episodes) do
      TradeLead::UkData.new("#{Rails.root}/spec/fixtures/trade_leads/uk/uk_trade_leads.csv").import
    end
    VCR.use_cassette("TradeLead_StateData/_import/loads_state_trade_leads_from_specified_resource", :record => :new_episodes) do
      TradeLead::StateData.new("#{Rails.root}/spec/fixtures/trade_leads/state/state_trade_leads.json").import
    end
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
