require 'spec_helper'

describe 'Canada Leads API V1', type: :request do
  before(:all) do
    TradeLead::Canada.recreate_index
    TradeLead::CanadaData.new(
        "#{Rails.root}/spec/fixtures/trade_leads/canada/canada_leads.csv").import

  end

  let(:search_path) { '/canada_leads/search' }
  let(:v1_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v1' } }
  let(:expected_results) { JSON.parse open("#{Rails.root}/spec/fixtures/trade_leads/canada/results_v1.json").read }

  describe 'GET /canada_leads/search.json' do
    context 'when search parameters are empty' do
      before { get search_path, { size: 100 }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns canada leads' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(5)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results).to match_array(expected_results)
      end
    end

    context 'when q is specified' do
      before { get search_path, { q: 'engineer' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns matching leads' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[3])
      end
    end

    context 'when industry is specified' do
      before { get search_path, { industries: 'dental' }, v1_headers }
      # before { get search_path, { industry: 'dental' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns matching leads' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[1])
      end
    end

    context 'when searching for field with non ascii characters using ascii characters' do
      before { get search_path, { q: 'Montée' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns matching leads' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[4])
      end
    end
  end
end
