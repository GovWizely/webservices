require 'spec_helper'

describe 'State Trade Leads API V2', type: :request do
  before(:all) do
    StateTradeLead.recreate_index
    StateTradeLeadData.new("#{Rails.root}/spec/fixtures/state_trade_leads/state_trade_leads.json").import
  end

  let(:expected_results) { YAML.load_file("#{Rails.root}/spec/fixtures/state_trade_leads/results.yaml") }
  let(:v2_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v2' } }

  describe 'GET /state_trade_leads/search' do
    let(:params) { {} }
    before { get '/state_trade_leads/search', params, v2_headers }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'a successful search request'

      it 'returns all documents' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(4)

        results = json_response[:results]

        # Order is different due to sort condition in query.
        expect(results[0]).to eq(expected_results[3])
        expect(results[1]).to eq(expected_results[2])
        expect(results[2]).to eq(expected_results[1])
        expect(results[3]).to eq(expected_results[0])
      end
    end

    context 'when q is specified' do
      let(:params) { { q: 'objective' } }

      subject { response }
      it_behaves_like 'a successful search request'

      it 'returns documents which contain the word "objective"' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(2)

        results = json_response[:results]
        expect(results[0]).to eq(expected_results[3])
        expect(results[1]).to eq(expected_results[1])
      end

      context 'when search term exists only in procurement_organization' do
        let(:params) { { q: 'department' } }
        it 'returns the document which contains the word "department"' do
          json_response = JSON.parse(response.body, symbolize_names: true)
          expect(json_response[:total]).to eq(1)

          results = json_response[:results]
          expect(results[0]).to eq(expected_results[1])
        end
      end

      context 'when search term exists only in tags' do
        let(:params) { { q: 'sanitation' } }
        it 'returns the document which contains the word "sanitation"' do
          json_response = JSON.parse(response.body, symbolize_names: true)
          expect(json_response[:total]).to eq(1)

          results = json_response[:results]
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
          json_response = JSON.parse(response.body, symbolize_names: true)
          expect(json_response[:total]).to eq(1)

          results = json_response[:results]
          expect(results[0]).to eq(expected_results[1])
        end
      end

      context 'two countries searched for' do
        let(:params) { { countries: 'ph,qa' } }
        it_behaves_like 'a successful search request'

        it 'returns the document with countries equal to PH' do
          json_response = JSON.parse(response.body, symbolize_names: true)
          expect(json_response[:total]).to eq(2)

          results = json_response[:results]
          expect(results[0]).to eq(expected_results[2])
          expect(results[1]).to eq(expected_results[1])
        end
      end
    end

    context 'when industry is specified' do
      let(:params) { { industry: 'Utilities' } }

      subject { response }
      it_behaves_like 'a successful search request'

      it 'returns documents with industry equal to "Utilities"' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(1)

        results = json_response[:results]
        expect(results[0]).to eq(expected_results[3])
      end
    end

    context 'when specific_location is specified' do
      let(:params) { { specific_location: 'qatar' } }

      subject { response }
      it_behaves_like 'a successful search request'

      it 'returns documents with specific_location matching "qatar"' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(1)

        results = json_response[:results]
        expect(results[0]).to eq(expected_results[2])
      end
    end
  end
end
