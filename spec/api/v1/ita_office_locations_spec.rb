require 'spec_helper'

describe 'ITA Office Locations API V1', type: :request do
  before(:all) do
    ItaOfficeLocation.recreate_index
    fixtures_dir = "#{Rails.root}/spec/fixtures/ita_office_locations"
    ItaOfficeLocationData.new(["#{fixtures_dir}/odo.xml", "#{fixtures_dir}/oio.xml"]).import
  end

  let(:v1_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v1' } }
  let(:expected_results) { JSON.parse open("#{Rails.root}/spec/fixtures/ita_office_locations/results.json").read }

  describe 'GET /ita_office_locations/search.json' do

    context 'when q is specified' do
      before { get '/ita_office_locations/search', { q: 'san jose' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns matching office locations' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(2)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[1])
        expect(results[1]).to eq(expected_results[0])
      end
    end

    context 'when country is specified' do
      before { get '/ita_office_locations/search', { q: 'saN Jose', country: 'Cr' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns trade events' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[1])
      end
    end

    context 'when USA and state is specified' do
      before { get '/ita_office_locations/search', { q: 'san jose', country: 'US', state: 'CA' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns trade events' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[0])
      end
    end

    context 'when just US state is specified' do
      before { get '/ita_office_locations/search', { q: 'san jose', state: 'CA' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns trade events' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[0])
      end
    end

    context 'when country and city are specified' do
      before { get '/ita_office_locations/search', { country: 'cr', city: 'san jose' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns trade events' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[1])
      end
    end

  end
end
