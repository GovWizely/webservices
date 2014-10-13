require 'spec_helper'

describe 'UK Trade Leads API V1' do
  before(:all) do
    UkTradeLead.recreate_index
    UkTradeLeadData.new("#{Rails.root}/spec/fixtures/uk_trade_leads/uk_trade_leads.csv").import
  end

  let(:expected_results) { YAML.load_file("#{Rails.root}/spec/fixtures/uk_trade_leads/results.yaml") }
  let(:v1_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v1' } }

  describe 'GET /uk_trade_leads/search' do
    let(:params) { {} }
    before { get '/uk_trade_leads/search', params, v1_headers }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'a successful search request'

      it 'returns all documents' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        json_response[:total].should == 3

        results = json_response[:results]

        # Order is different due to sort condition in query.
        results[0].should == expected_results[1]
        results[1].should == expected_results[0]
        results[2].should == expected_results[2]
      end
    end

    context 'when q is specified' do
      let(:params) { { q: 'and' } }

      subject { response }
      it_behaves_like 'a successful search request'

      it 'returns documents which contain the word "and"' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        json_response[:total].should == 2

        results = json_response[:results]
        results.should match_array([expected_results[0], expected_results[2]])
      end

      context 'when industry is specified' do
        let(:params) { { industry: '85000000' } }

        subject { response }
        it_behaves_like 'a successful search request'

        it 'returns documents with industry equal to "85000000"' do
          json_response = JSON.parse(response.body, symbolize_names: true)
          json_response[:total].should == 1

          results = json_response[:results]
          results[0].should == expected_results[0]
        end
      end

      context 'when search term exists only in procurement_organization' do
        let(:params) { { q: 'limited' } }
        it 'returns the document which contains the word "limited"' do
          json_response = JSON.parse(response.body, symbolize_names: true)
          json_response[:total].should == 1

          results = json_response[:results]
          results[0].should == expected_results[2]
        end
      end
    end

  end
end
