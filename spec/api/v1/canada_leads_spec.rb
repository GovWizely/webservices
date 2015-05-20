require 'spec_helper'

describe 'Canada Leads API V1', type: :request do
  before(:all) do
    TradeLead::Canada.recreate_index
    TradeLead::CanadaData.new(
      "#{Rails.root}/spec/fixtures/trade_leads/canada/canada_leads.csv").import
  end

  let(:search_path) { '/canada_leads/search' }
  let(:expected_results) { JSON.parse open("#{File.dirname(__FILE__)}/trade_leads/canada/results.json").read }

  describe 'GET /canada_leads/search.json' do
    context 'when search parameters are empty' do
      before { get search_path, size: 100 }
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
      let(:params) { { q: 'engineer' } }
      before { get search_path, params }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns matching leads' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[3])
      end
      it_behaves_like "an empty result when a query doesn't match any documents"
    end

    context 'when industry is specified' do
      let(:params) { { industries: 'dental' } }
      before { get search_path, params }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns matching leads' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[1])
      end
      it_behaves_like "an empty result when an industries search doesn't match any documents"
    end

    context 'when searching for field with non ascii characters using ascii characters' do
      before { get search_path, q: 'Montée' }
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
