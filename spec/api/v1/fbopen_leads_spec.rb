require 'spec_helper'

describe 'Fbopen Leads API V1' do
  before(:all) do
    FbopenLead.recreate_index
    FbopenLeadData.new("#{Rails.root}/spec/fixtures/fbopen_leads/short_input").import
  end

  let(:search_path) { '/fbopen_leads/search' }
  let(:v1_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v1' } }
  let(:expected_results) { JSON.parse open("#{Rails.root}/spec/fixtures/fbopen_leads/results.json").read }

  describe 'GET /fbopen_leads/search.json' do
    context 'when search parameters are empty' do
      before { get search_path, { size: 100 }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns fbopen leads' do
        json_response = JSON.parse(response.body)
        json_response['total'].should == 6
        json_response['offset'].should == 0

        results = json_response['results']
        results.should include(*expected_results)
      end
    end

    context 'when q is specified' do
      before { get search_path, { q: 'toilETs' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns matching leads' do
        json_response = JSON.parse(response.body)
        json_response['total'].should == 1
        json_response['offset'].should == 0

        results = json_response['results']
        results[0].should == expected_results[5]
      end
    end

    context 'when industry is specified' do
      before { get search_path, { industry: '337920' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns matching leads' do
        json_response = JSON.parse(response.body)
        json_response['total'].should == 2
        json_response['offset'].should == 0

        results = json_response['results']
        results.should include(expected_results[1])
        results.should include(expected_results[2])
      end
    end

    context 'when specific_location is specified' do
      before { get search_path, { specific_location: 'BR' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns matching leads' do
        json_response = JSON.parse(response.body)
        json_response['total'].should == 3
        json_response['offset'].should == 0

        results = json_response['results']
        results[0].should == expected_results[0]
        results[1].should == expected_results[4]
        results[2].should == expected_results[5]
      end
    end
  end
end
