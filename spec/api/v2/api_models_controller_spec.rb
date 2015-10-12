require 'spec_helper'

describe 'API models V2', type: :request do
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
        results = JSON.parse(response.body)
        expect(results.first).to match(a_hash_including(one_match.first))
      end
    end
  end
end
