require 'spec_helper'

describe 'State Trade Leads API V1', type: :request do
  before(:all) do
    VCR.use_cassette("TradeLead_StateData/_import/loads_state_trade_leads_from_specified_resource", :record => :new_episodes) do
      TradeLead::State.recreate_index
      TradeLead::StateData.new(
          "#{Rails.root}/spec/fixtures/trade_leads/state/state_trade_leads.json").import
    end
  end
  let(:expected_results) { JSON.parse(open("#{Rails.root}/spec/fixtures/trade_leads/state/results_v1.json").read) }
  let(:v1_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v1' } }

  describe 'GET /state_trade_leads/search' do
    let(:params) { {} }
    before { get '/state_trade_leads/search', params, v1_headers }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'a successful search request'

      it 'returns all documents' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(4)
        results = json_response['results']
        expect(results).to match_array(expected_results)
      end
    end

    context 'when q is specified' do
      let(:params) { { q: 'objective' } }

      subject { response }
      it_behaves_like 'a successful search request'

      it 'returns documents which contain the word "objective"' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(2)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[3])
        expect(results[1]).to eq(expected_results[1])
      end

      context 'when search term exists only in procurement_organization' do
        let(:params) { { q: 'department' } }
        it 'returns the document which contains the word "department"' do
          json_response = JSON.parse(response.body)
          expect(json_response['total']).to eq(1)

          results = json_response['results']
          expect(results[0]).to eq(expected_results[1])
        end
      end

      context 'when search term exists only in tags' do
        let(:params) { { q: 'sanitation' } }
        it 'returns the document which contains the word "sanitation"' do
          json_response = JSON.parse(response.body)
          expect(json_response['total']).to eq(1)

          results = json_response['results']
          expect(results[0]).to eq(expected_results[3])
        end
      end
    end

    context 'when countries is specified' do
      subject { response }

      context 'one country searched for' do
        let(:params) { { countries: 'PH' } }
        it_behaves_like 'a successful search request'

        it 'returns the document with countries equal to PH' do
          json_response = JSON.parse(response.body)
          expect(json_response['total']).to eq(1)

          results = json_response['results']
          expect(results[0]).to eq(expected_results[1])
        end
      end

      context 'two countries searched for' do
        let(:params) { { countries: 'ph,qa' } }
        it_behaves_like 'a successful search request'

        it 'returns the document with countries equal to PH' do
          json_response = JSON.parse(response.body)
          expect(json_response['total']).to eq(2)

          results = json_response['results']

          expect(results[0]).to eq(expected_results[1])
          expect(results[1]).to eq(expected_results[2])
        end
      end
    end

    context 'when industry is specified' do
      let(:params) { { industries: 'Utilities' } }

      subject { response }
      it_behaves_like 'a successful search request'

      it 'returns documents with industry equal to "Utilities"' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[3])
      end
    end
  end
end
