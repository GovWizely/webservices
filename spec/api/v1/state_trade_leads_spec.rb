require 'spec_helper'

describe 'State Trade Leads API V1' do
  before(:all) do
    StateTradeLead.recreate_index
    StateTradeLeadData.new("#{Rails.root}/spec/fixtures/state_trade_leads/state_trade_leads.json").import
  end

  let(:expected_results) { YAML.load_file("#{Rails.root}/spec/fixtures/state_trade_leads/results.yaml") }
  let(:v1_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v1' } }

  describe 'GET /state_trade_leads/search' do
    let(:params) { {} }
    before { get '/state_trade_leads/search', params, v1_headers }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'a successful search request'

      it 'returns all documents' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        json_response[:total].should == 4

        results = json_response[:results]

        # Order is different due to sort condition in query.
        results[0].should == expected_results[3]
        results[1].should == expected_results[2]
        results[2].should == expected_results[1]
        results[3].should == expected_results[0]
      end
    end

    context 'when q is specified' do
      let(:params) { { q: 'objective' } }

      subject { response }
      it_behaves_like 'a successful search request'

      it 'returns documents which contain the word "objective"' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        json_response[:total].should == 2

        results = json_response[:results]
        results[0].should == expected_results[3]
        results[1].should == expected_results[1]
      end

      context 'when search term exists only in procurement_organization' do
        let(:params) { { q: 'department' } }
        it 'returns the document which contains the word "department"' do
          json_response = JSON.parse(response.body, symbolize_names: true)
          json_response[:total].should == 1

          results = json_response[:results]
          results[0].should == expected_results[1]
        end
      end

      context 'when search term exists only in tags' do
        let(:params) { { q: 'sanitation' } }
        it 'returns the document which contains the word "sanitation"' do
          json_response = JSON.parse(response.body, symbolize_names: true)
          json_response[:total].should == 1

          results = json_response[:results]
          results[0].should == expected_results[3]
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
          json_response[:total].should == 1

          results = json_response[:results]
          results[0].should == expected_results[1]
        end
      end

      context 'two countries searched for' do
        let(:params) { { countries: 'ph,qa' } }
        it_behaves_like 'a successful search request'

        it 'returns the document with countries equal to PH' do
          json_response = JSON.parse(response.body, symbolize_names: true)
          json_response[:total].should == 2

          results = json_response[:results]
          results[0].should == expected_results[2]
          results[1].should == expected_results[1]
        end
      end
    end

    context 'when industry is specified' do
      let(:params) { { industry: 'Utilities' } }

      subject { response }
      it_behaves_like 'a successful search request'

      it 'returns documents with industry equal to "Utilities"' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        json_response[:total].should == 1

        results = json_response[:results]
        results[0].should == expected_results[3]
      end
    end

    context 'when specific_location is specified' do
      let(:params) { { specific_location: 'qatar' } }

      subject { response }
      it_behaves_like 'a successful search request'

      it 'returns documents with specific_location matching "qatar"' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        json_response[:total].should == 1

        results = json_response[:results]
        results[0].should == expected_results[2]
      end
    end
  end
end
