require 'spec_helper'

describe 'Canada Leads API V1' do
  before(:all) do
    CanadaLead.recreate_index
    CanadaLeadData.new("#{Rails.root}/spec/fixtures/canada_leads/canada_leads.csv").import
  end

  let(:search_path) { '/canada_leads/search' }
  let(:v1_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v1' } }
  let(:expected_results) { JSON.parse open("#{Rails.root}/spec/fixtures/canada_leads/results.json").read }

  describe 'GET /canada_leads/search.json' do
    context 'when search parameters are empty' do
      before { get search_path, { size: 100 }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns canada leads' do
        json_response = JSON.parse(response.body)
        json_response['total'].should == 5
        json_response['offset'].should == 0

        results = json_response['results']
        results[0].should == expected_results[0]
        results[1].should == expected_results[1]
        results[2].should == expected_results[2]
        results[3].should == expected_results[3]
        results[4].should == expected_results[4]
      end
    end

    context 'when q is specified' do
      before { get search_path, { q: 'engineer' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns matching leads' do
        json_response = JSON.parse(response.body)
        json_response['total'].should == 1
        json_response['offset'].should == 0

        results = json_response['results']
        results[0].should == expected_results[3]
      end
    end

    context 'when industry is specified' do
      before { get search_path, { industry: 'dental' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns matching leads' do
        json_response = JSON.parse(response.body)
        json_response['total'].should == 1
        json_response['offset'].should == 0

        results = json_response['results']
        results[0].should == expected_results[1]
      end
    end

    context 'when specific_location is specified' do
      before { get search_path, { specific_location: 'Manitoba' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns matching leads' do
        json_response = JSON.parse(response.body)
        json_response['total'].should == 1
        json_response['offset'].should == 0

        results = json_response['results']
        results[0].should == expected_results[2]
      end
    end

    context 'when searching for field with non ascii characters using ascii characters' do
      before { get search_path, { q: 'Montée' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns matching leads' do
        json_response = JSON.parse(response.body)
        json_response['total'].should == 1
        json_response['offset'].should == 0

        results = json_response['results']
        results[0].should == expected_results[4]
      end
    end
  end
end
