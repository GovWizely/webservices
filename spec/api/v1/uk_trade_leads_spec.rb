require 'spec_helper'

describe 'UK Trade Leads API V1', type: :request do

  before(:all) do
    TradeLead::Uk.recreate_index
    TradeLead::UkData.new(
        "#{Rails.root}/spec/fixtures/trade_leads/uk/uk_trade_leads.csv").import
  end
  let(:expected_results) do
    JSON.parse(open("#{File.dirname(__FILE__)}/trade_leads/uk/results.json").read,
               symbolize_names: true)
  end
  let(:v1_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v1' } }

  describe 'GET /uk_trade_leads/search' do
    let(:params) { {} }
    before { get '/uk_trade_leads/search', params, v1_headers }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'a successful search request'

      it 'returns all documents' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(3)
        results = json_response[:results]
        expect(results).to match_array(expected_results)
      end
    end

    context 'when q is specified' do
      let(:params) { { q: 'and' } }

      subject { response }
      it_behaves_like 'a successful search request'

      it 'returns documents which contain the word "and"' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(2)

        results = json_response[:results]
        expect(results).to match_array([expected_results[0], expected_results[2]])
      end

      context 'when industry is specified' do
        let(:params) { { industries: '85000000' } }

        subject { response }
        it_behaves_like 'a successful search request'

        it 'returns documents with industry equal to "85000000"' do
          json_response = JSON.parse(response.body, symbolize_names: true)
          expect(json_response[:total]).to eq(1)

          results = json_response[:results]
          expect(results[0]).to eq(expected_results[0])
        end
      end

      context 'when search term exists only in procurement_organization' do
        let(:params) { { q: 'limited' } }
        it 'returns the document which contains the word "limited"' do
          json_response = JSON.parse(response.body, symbolize_names: true)
          expect(json_response[:total]).to eq(1)

          results = json_response[:results]
          expect(results[0]).to eq(expected_results[2])
        end
      end
      it_behaves_like "an empty result when a query doesn't match any documents"
    end

  end
end
