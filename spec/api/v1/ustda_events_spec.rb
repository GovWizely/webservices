require 'spec_helper'

describe 'Trade Events API V1' do
  before(:all) do
    UstdaEvent.recreate_index
    UstdaEventData.new("#{Rails.root}/spec/fixtures/ustda_events/events.csv").import
  end

  let(:v1_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v1' } }
  let(:expected_results) { JSON.parse open("#{Rails.root}/spec/fixtures/ustda_events/results.json").read }

  before do
    Date.stub(:current).and_return(Date.parse('2013-10-07'))
  end

  describe 'GET /ustda_events/search.json' do
    context 'when search parameters are empty' do
      before { get '/ustda_events/search', {}, v1_headers }
      subject { response }

      include_examples 'a successful search request'

      it 'returns trade events' do
        json_response = JSON.parse(response.body)
        json_response['total'].should == 5
        json_response['offset'].should == 0

        results = json_response['results']
        results.should match_array(expected_results)
      end
    end

    context 'when q is specified' do
      before { get '/ustda_events/search', { q: 'aviation' }, v1_headers }
      subject { response }

      include_examples 'a successful search request'

      it 'returns trade events' do
        json_response = JSON.parse(response.body)
        json_response['total'].should == 3
        json_response['offset'].should == 0

        results = json_response['results']
        results.should match_array(expected_results.values_at(1, 2, 4))
      end
    end

    context 'when countries is specified' do
      before { get '/ustda_events/search', { countries: 'us' }, v1_headers }
      subject { response }

      include_examples 'a successful search request'

      it 'returns trade events' do
        json_response = JSON.parse(response.body)
        json_response['total'].should == 5
        json_response['offset'].should == 0

        results = json_response['results']
        results.should match_array(expected_results)
      end
    end

    context 'when industry is specified' do
      before { get '/ustda_events/search', { industry: 'mining' }, v1_headers }
      subject { response }

      include_examples 'a successful search request'

      it 'returns trade events' do
        json_response = JSON.parse(response.body)
        json_response['total'].should == 2
        json_response['offset'].should == 0

        results = json_response['results']
        results.should match_array(expected_results.values_at(0, 3))
      end
    end
  end
end
