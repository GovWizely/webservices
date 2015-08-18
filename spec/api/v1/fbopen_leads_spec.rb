require 'spec_helper'

describe 'Fbopen Leads API V1', type: :request do
  before(:all) do
    TradeLead::Fbopen.recreate_index
    TradeLead::FbopenImporter::PatchData.new(
      "#{Rails.root}/spec/fixtures/trade_leads/fbopen/patch_source_short_input").import
  end

  let(:search_path) { '/v1/fbopen_leads/search' }
  let(:expected_results) do
    JSON.parse(open("#{File.dirname(__FILE__)}/trade_leads/fbopen/results.json").read)
  end

  describe 'GET /v1/fbopen_leads/search' do
    context 'when search parameters are empty' do
      before { get search_path, size: 100 }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns fbopen leads' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(3)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results).to include(*expected_results)
      end
    end

    context 'when q is specified' do
      let(:params) { { q: 'toilETs' } }
      before { get search_path, params }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns matching leads' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[2])
      end
      it_behaves_like "an empty result when a query doesn't match any documents"
    end

    context 'when industry is specified' do
      let(:params) { { industries: '812320' } }
      before { get search_path, params }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns matching leads' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results).to include(expected_results[0])
      end
      it_behaves_like "an empty result when an industries search doesn't match any documents"
    end
  end
end
