require 'spec_helper'

describe Api::V2::ApiModelsController, type: :request do
  include_context 'V2 headers'
  before(:all) do
    csv = File.read "#{Rails.root}/spec/fixtures/data_sources/de_minimis_date.csv"
    dictionary_yaml = File.read "#{Rails.root}/spec/fixtures/data_sources/de_minimis_dictionary.yaml"
    data_source = DataSource.create(_id: 'de_minimis_currencies', name: 'test', description: 'test API',
                                    api: 'de_minimis_currencies', data: csv, dictionary: dictionary_yaml)
    data_source.ingest
  end

  describe 'GET /de_minimis_currencies/search.json' do
    context 'when one document matches a query and filter' do
      let(:one_match) { JSON.parse Rails.root.join("#{File.dirname(__FILE__)}/data_sources/one_match.json").read }
      let(:params) { { q: 'exceeding', date: '2015-10-01 TO 2015-10-02', de_minimis_currency: 'USD' } }
      before { get '/de_minimis_currencies/search', params, @v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns the only result matching the query and filter' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results.first).to match(a_hash_including(one_match.first))
      end

      it 'includes metadata' do
        data_source = DataSource.find 'de_minimis_currencies'
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:sources_used]).to eq(source:              data_source.name,
                                                   source_last_updated: data_source.updated_at.as_json,
                                                   last_imported:       data_source.updated_at.as_json)
      end

      it_behaves_like "an empty result when a query doesn't match any documents"
    end
  end
end
