require 'spec_helper'

describe 'Trade Events API V1', type: :request do
  before(:all) do
    TradeEvent.recreate_index
    TradeEventData.new("#{Rails.root}/spec/fixtures/trade_events/trade_events.xml").import
  end

  let(:v1_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v1' } }
  let(:expected_results) { JSON.parse open("#{Rails.root}/spec/fixtures/trade_events/results.json").read }

  describe 'GET /trade_events/search.json' do
    context 'when search parameters are empty' do
      before { get '/trade_events/search', {}, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns trade events' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(4)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[0])
        expect(results[1]).to eq(expected_results[1])
        expect(results[2]).to eq(expected_results[2])
        expect(results[3]).to eq(expected_results[3])
      end
    end

    context 'when q is specified' do
      before { get '/trade_events/search', { q: '2013' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns trade events' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(2)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[0])
        expect(results[1]).to eq(expected_results[2])
      end
    end

    context 'when countries is specified' do
      before { get '/trade_events/search', { countries: 'il' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns trade events' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[0])
      end
    end

    context 'when industry is specified' do
      before { get '/trade_events/search', { industry: 'DENTALS' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns trade events' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[0])
      end
    end

    context 'when searching for field with non ascii characters using ascii characters' do
      before { get '/trade_events/search', { q: 'Sao' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns trade events' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[3])
      end
    end
  end
end
