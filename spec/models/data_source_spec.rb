require 'spec_helper'

describe DataSource do
  describe 'validations' do
    it do
      is_expected.to validate_presence_of(:name)
      is_expected.to validate_presence_of(:api)
      is_expected.to validate_presence_of(:version_number)
      is_expected.to validate_numericality_of(:version_number)
    end

    ['foo bar', 'de-minimis', "loren's", 'Currencies'].each do |bad_value|
      it { is_expected.not_to allow_value(bad_value).for(:api) }
    end

    %w(ita_taxonomy screening_lists api_models).each do |existing_api|
      it { is_expected.not_to allow_value(existing_api).for(:api) }
    end

    %w(de_minimis_currencies area_51_residents business_service_providers).each do |ok_value|
      it { is_expected.to allow_value(ok_value).for(:api) }
    end
  end

  describe 'lifecycle callbacks' do
    let(:data_source) { DataSource.new(_id: 'some_things:v2', name: 'test', description: 'test API', api: 'some_things', data: 'CSV as String', version_number: 2) }

    before do
      parser = instance_double(DataSources::CSVParser, generate_dictionary: { field1: 'foo', field2: 'bar' })
      expect(DataSources::CSVParser).to receive(:new).with('CSV as String').and_return parser
      data_source.save
    end

    describe 'saving a data source' do
      it 'builds the data dictionary based on the uploaded CSV data' do
        expect(data_source.dictionary).to eq("---\n:field1: foo\n:field2: bar\n")
      end
    end

    describe 'destroying a data source' do
      it 'deletes the API index in Elasticsearch' do
        expect(ES.client.indices).to receive(:delete).with(index: 'test:webservices:api_models:some_things:v2', ignore: 404)
        data_source.destroy
      end
    end
  end

  describe 'ingest' do
    context 'basic upload with header conversion' do
      let(:data_source) { DataSource.create(_id: 'test_currencies:v1', published: true, version_number: 1, name: 'test', description: 'test API', api: 'test_currencies', data: File.read("#{Rails.root}/spec/fixtures/data_sources/currencies.csv"), dictionary: '') }
      let(:dictionary) { DataSources::Metadata.new(File.read("#{Rails.root}/spec/fixtures/data_sources/currencies.yaml")).deep_symbolized_yaml }

      before do
        data_source.ingest
        data_source.with_api_model do |klass|
          expect(klass.count).to eq(2)
          query = ApiModelQuery.new(data_source.metadata, ActionController::Parameters.new(country: 'Armenia'))
          expect(klass.search(query.generate_search_body_hash).first.iso2_code).to eq('AM')
          data_source.update(dictionary: dictionary)
        end
        data_source.ingest
      end

      it 'creates entries in the new api index with the new class constant' do
        results = data_source.with_api_model do |klass|
          query = ApiModelQuery.new(data_source.metadata, ActionController::Parameters.new(country_name: 'Armenia'))
          klass.search(query.generate_search_body_hash)
        end
        expect(results.first.iso_code).to eq('AM')
        expect(Webservices::ApiModels.constants).to include(:TestCurrency)
        expect(results.first.tariff_line).to eq('010210')
      end
    end

    context 'specifying uniqueness constraints on column values' do
      let(:data_source) { DataSource.create(_id: 'test_dupes:v1', published: true, version_number: 1, name: 'test', description: 'test dupes', api: 'test_dupes', data: File.read("#{Rails.root}/spec/fixtures/data_sources/dupes.csv"), dictionary: '') }
      let(:dictionary) { DataSources::Metadata.new(File.read("#{Rails.root}/spec/fixtures/data_sources/dupes.yaml")).deep_symbolized_yaml }

      before do
        data_source.ingest
        data_source.with_api_model do |klass|
          expect(klass.count).to eq(3)
          data_source.update(dictionary: dictionary)
        end
        data_source.ingest
      end

      it 'creates entries using an ID formed from a hash of use_for_id fields' do
        results = data_source.with_api_model do |klass|
          expect(klass.count).to eq(2)
          query = ApiModelQuery.new(data_source.metadata, ActionController::Parameters.new(country_name: 'United Kingdom'))
          klass.search(query.generate_search_body_hash)
        end
        expect(results.first.f1).to eq('val3 should override val1')
      end
    end

    context 'specifying constant column value' do
      %w(json xml csv).each do |format|
        let(:data_source) { DataSource.create(_id: "test_constants_#{format}:v1", published: true, version_number: 1, name: 'test', description: 'test constants', api: "test_constants_#{format}", data: File.read("#{Rails.root}/spec/fixtures/data_sources/constants.#{format}"), dictionary: '') }
        let(:dictionary) { DataSources::Metadata.new(File.read("#{Rails.root}/spec/fixtures/data_sources/constants_#{format}.yaml")).deep_symbolized_yaml }

        before do
          data_source.update(dictionary: dictionary)
          data_source.ingest
        end

        it 'creates entries with constant column value field' do
          results = data_source.with_api_model do |klass|
            expect(klass.count).to eq(2)
            query = ApiModelQuery.new(data_source.metadata, ActionController::Parameters.new(source: 'some constant value'))
            klass.search(query.generate_search_body_hash)
          end
          expect(results.collect(&:source)).to eq(['some constant value', 'some constant value'])
        end
      end
    end

    context 'specifying copied fields' do
      %w(csv json xml).each do |format|
        let(:data_source) { DataSource.create(_id: "test_copied_fields_#{format}:v1", published: true, version_number: 1, name: 'test', description: 'test copied fields', api: "test_copied_fields_#{format}", data: File.read("#{Rails.root}/spec/fixtures/data_sources/copied_fields.#{format}"), dictionary: '') }
        let(:dictionary) { DataSources::Metadata.new(File.read("#{Rails.root}/spec/fixtures/data_sources/copied_fields_#{format}.yaml")).deep_symbolized_yaml }

        before do
          data_source.update(dictionary: dictionary)
          data_source.ingest
        end

        it 'creates entries with field copied from source field and transformed' do
          results = data_source.with_api_model do |klass|
            expect(klass.count).to eq(2)
            query = ApiModelQuery.new(data_source.metadata, ActionController::Parameters.new(f3: 'VAL1FROMCOMMAS', f4: 'val1 to commas'))
            klass.search(query.generate_search_body_hash)
          end
          expect(results.first.f3).to eq('VAL1FROMCOMMAS')
          expect(results.first.f4).to eq('val1 to commas')
        end
      end
    end

    context 'grouping fields under parent fields' do
      let(:data_source) { DataSource.create(_id: 'test_groups:v1', published: true, version_number: 1, name: 'test', description: 'test groups', api: 'test_groups', data: File.read("#{Rails.root}/spec/fixtures/data_sources/groups.csv"), dictionary: '') }
      let(:dictionary) { DataSources::Metadata.new(File.read("#{Rails.root}/spec/fixtures/data_sources/groups.yaml")).deep_symbolized_yaml }

      before do
        data_source.ingest
        data_source.with_api_model do |_klass|
          data_source.update(dictionary: dictionary)
        end
        data_source.ingest
      end

      it 'creates entries with grouped column value fields' do
        results = data_source.with_api_model do |klass|
          expect(klass.count).to eq(2)
          query = ApiModelQuery.new(data_source.metadata, ActionController::Parameters.new(title: 'bar'))
          klass.search(query.generate_search_body_hash)
        end
        expect(results.first.title).to eq('bar')
        expect(results.first.annual_rates).to eq('field1' => 'feeling', 'field2' => 'sick', 'field3' => '4.5')
        expect(results.first.annual_rates_alt).to eq('field1_alt' => 'started', 'field2_alt' => 'preschool', 'field3_alt' => '666')
      end
    end

    context 'specifying nested collections' do
      let(:data_source) { DataSource.create(_id: 'test_nested_collections:v1', published: true, version_number: 1, name: 'test', description: 'test nested_collections', api: 'test_nested_collections', data: File.read("#{Rails.root}/spec/fixtures/data_sources/nested_collections.json"), dictionary: '') }
      let(:dictionary) { DataSources::Metadata.new(File.read("#{Rails.root}/spec/fixtures/data_sources/nested_collections.yaml")).deep_symbolized_yaml }

      before do
        data_source.update(dictionary: dictionary)
        data_source.ingest
      end

      it 'creates entries with nested collections' do
        results = data_source.with_api_model do |klass|
          expect(klass.count).to eq(2)
          params = { mname: 'Karl', lname: 'torres', q: 'norte', country_codes: 'us,il', bday: '2010-07-01 TO 2010-07-01' }
          query = ApiModelQuery.new(data_source.metadata, ActionController::Parameters.new(params))
          klass.search(query.generate_search_body_hash)
        end
        expect(results.total).to eq(1)
        expect(results.first.name).to eq('foo')
        expect(results.first.contacts).to eq([{ 'myfloat' => 31.14, 'bday' => '2010-07-01', 'fname' => 'Yael', 'lname' => 'Torres', 'mname' => 'karl' }])
        expect(results.first.places).to eq([{ 'country_code' => 'IL', 'country_name' => 'il', 'venue' => 'International Convention Center, Haifa, Israel' }, { 'country_code' => 'BR', 'country_name' => 'br', 'venue' => 'Expo Center Norte' }, { 'country_code' => 'US', 'country_name' => 'us', 'venue' => 'WCTC - Richard T Anderson Building' }])
      end

      it 'creates correct aggregations of nested fields' do
        results = data_source.with_api_model do |klass|
          query = ApiModelQuery.new(data_source.metadata, ActionController::Parameters.new)
          klass.search(query.generate_search_body_hash)
        end
        aggs = results.response.aggregations
        expect(aggs['country_codes'].buckets).to eq([{ 'key' => 'US', 'doc_count' => 2 },
                                                     { 'key' => 'BR', 'doc_count' => 1 },
                                                     { 'key' => 'CG', 'doc_count' => 1 },
                                                     { 'key' => 'IL', 'doc_count' => 1 },],)
      end
    end
  end

  describe 'search' do
    describe 'recall & relevancy' do
      let(:data_source) { DataSource.create(_id: 'recall_and_relevancies:v4', published: true, version_number: 4, name: 'test', description: 'test API', api: 'recall_and_relevancies', data: "Country,ISO-2 code,free_text\r\nAndorra,AD,foo\r\nArmenia,AM,foo\r\nCanada,CA,accént\r\n") }
      let(:dictionary) { DataSources::Metadata.new(File.read("#{Rails.root}/spec/fixtures/data_sources/recall_and_relevancies.yaml")).deep_symbolized_yaml }

      before do
        data_source.update(dictionary: dictionary)
        data_source.ingest
      end

      describe 'recall' do
        it 'matches enum filter terms regardless of case' do
          results = data_source.with_api_model do |klass|
            query = ApiModelQuery.new(data_source.metadata, ActionController::Parameters.new(country_name: 'ANDORRA', iso2_codes: 'aD'))
            klass.search(query.generate_search_body_hash)
          end
          expect(results.size).to eq(1)
        end

        it 'matches multiple filter terms separated by commas' do
          results = data_source.with_api_model do |klass|
            query = ApiModelQuery.new(data_source.metadata, ActionController::Parameters.new(iso2_codes: 'AD, ca'))
            klass.search(query.generate_search_body_hash)
          end
          expect(results.size).to eq(2)
        end

        it 'matches on fulltext regardless of accented characters' do
          results = data_source.with_api_model do |klass|
            query = ApiModelQuery.new(data_source.metadata, ActionController::Parameters.new(q: 'åccent'))
            klass.search(query.generate_search_body_hash)
          end
          expect(results.size).to eq(1)
        end
      end
    end

    describe 'semantic query pre-processing' do
      let(:data_source) { DataSource.create(_id: 'sqs:v1', published: true, version_number: 1, name: 'test_sqs', description: 'test sqs', api: 'test_sqs', data: File.read("#{Rails.root}/spec/fixtures/data_sources/sqs.json")) }
      let(:dictionary) { DataSources::Metadata.new(File.read("#{Rails.root}/spec/fixtures/data_sources/sqs.yaml")).deep_symbolized_yaml }

      before do
        data_source.update(dictionary: dictionary)
        data_source.ingest
      end

      it 'prioritizes semantic terms over fulltext match' do
        results = data_source.with_api_model do |klass|
          VCR.use_cassette('importers/data_sources/semantic_query_service/brazil.yml', record: :once) do
            query = ApiModelQuery.new(data_source.metadata, ActionController::Parameters.new(q: 'brazil'))
            klass.search(query.generate_search_body_hash)
          end
        end
        expect(results.first.field1).to eq('prioritize semantic extraction of country name')
        expect(results.last.field1).to eq('Brazil')
      end
    end

    describe 'aggregations' do
      let(:data_source) { DataSource.create(_id: 'aggs:v1', published: true, version_number: 1, name: 'test_aggs', description: 'test aggs', api: 'test_aggs', data: File.read("#{Rails.root}/spec/fixtures/data_sources/aggs.json")) }
      let(:dictionary) { DataSources::Metadata.new(File.read("#{Rails.root}/spec/fixtures/data_sources/aggs.yaml")).deep_symbolized_yaml }

      before do
        data_source.update(dictionary: dictionary)
        data_source.ingest
      end

      it 'returns expected aggregations' do
        results = data_source.with_api_model do |klass|
          query = ApiModelQuery.new(data_source.metadata, ActionController::Parameters.new(q: 'val'))
          klass.search(query.generate_search_body_hash)
        end
        expect(results.size).to eq(6)
        aggs = results.response.aggregations
        expect(aggs['country_codes'].buckets).to eq([{ 'key' => 'US', 'doc_count' => 3 },
                                                     { 'key' => 'CA', 'doc_count' => 2 },
                                                     { 'key' => 'BR', 'doc_count' => 1 },],)
        expect(aggs['world_regions'].buckets).to eq([{ 'key' => 'Blat Too', 'doc_count' => 4 },
                                                     { 'key' => 'Bar', 'doc_count' => 3 },
                                                     { 'key' => 'Foo', 'doc_count' => 3 },],)
      end
    end
  end

  describe 'consolidated_data_sources(whitelist)' do
    let(:data_source) { DataSource.new }
    before { allow(data_source).to receive(:sources_map).and_return({ a: 1, b: 2, c: 3 }.with_indifferent_access) }

    context 'no specified sources actually exist' do
      it 'returns all children sources for this consolidated data source' do
        expect(data_source.consolidated_data_sources('nope,none')).to eq([1, 2, 3])
      end
    end

    context 'at least one specified source actually exists' do
      it 'returns matching children sources for this consolidated data source' do
        expect(data_source.consolidated_data_sources('nope,none,c')).to eq([3])
      end
    end
  end

  describe '.find_published(api, version_number)' do
    before do
      query_hash = { query: { bool: { filter: [{ term: { _id: 'my_api:v2' } }, { term: { published: true } }] } }, _source: { excludes: ['data'] } }
      expect(DataSource).to receive(:search).with(query_hash).and_return ['expected data source']
    end

    it 'returns the first published DataSource without the data field that matches the api and version number' do
      expect(DataSource.find_published('my_api', 2)).to eq('expected data source')
    end
  end

  describe '.freshen(api)' do
    let(:data_source) { DataSource.create(_id: 'freshen_api:v2', published: true, version_number: 2, name: 'test', description: 'test API', api: 'freshen_api', data: "foo,bar\n3,4", url: 'http://some.url.gov/data.csv') }

    before do
      DataSource.create(_id: 'freshen_api:v1', published: true, version_number: 1, name: 'test', description: 'test API', api: 'freshen_api', data: "foo,bar\n1,2", url: 'http://some.url.gov/data.csv')
      expect(DataSource).to receive(:find_published).with('freshen_api', 2, false).and_return data_source
      DataSource.refresh_index!
    end

    it 'calls freshen on the most recent published data_source instance' do
      expect(data_source).to receive(:freshen)
      DataSource.freshen('freshen_api')
    end
  end

  describe 'freshen' do
    let(:url) { 'http://some.url.gov/data.csv' }
    let(:original_data) { "f1,f2\none,two\nthree,four" }
    let(:new_data) { "f1,f2\none,two\nthree,five" }
    let(:data_source) { DataSource.create(_id: 'maybe_freshen_api:v1', published: true, version_number: 1, name: 'test', description: 'test API', api: 'maybe_freshen_api', data: original_data, url: url, message_digest: '74092f827c24705e433b66a3e43797e187cf9500') }

    before do
      data_source.ingest
    end

    context 'data has not changed' do
      let(:data_extractor) { instance_double(DataSources::DataExtractor, data: original_data) }

      before do
        expect(DataSources::DataExtractor).to receive(:new).with(url).and_return data_extractor
      end

      it 'does not receive update' do
        expect(data_source).not_to receive(:update)
        data_source.freshen
      end
    end

    context 'data has changed' do
      let(:data_extractor) { instance_double(DataSources::DataExtractor, data: new_data) }
      let(:timestamp) { Time.now.utc }

      before do
        expect(data_source).to receive(:updated_timestamp).and_return timestamp
        expect(DataSources::DataExtractor).to receive(:new).with(url).and_return data_extractor
      end

      it 'gets updated with new data, new digest, and new data_imported_at timestamp' do
        expect(data_source).to receive(:update).with(data: new_data, message_digest: 'bbea15f33e4e76fefec2aadc9209dd71c5f37846', data_changed_at: timestamp, data_imported_at: timestamp)
        data_source.freshen
      end

      it 'inserts/updates data and deletes any existing records that are not in the updated data set' do
        sleep(1.1)
        data_source.dictionary = "---\r\n:f1:\r\n  :source: f1\r\n  :description: Description of f1\r\n  :indexed: true\r\n  :plural: true\r\n  :type: enum\r\n:f2:\r\n  :source: f2\r\n  :description: Description of f2\r\n  :indexed: true\r\n  :plural: true\r\n  :type: enum\r\n"
        data_source.freshen
        data_source.with_api_model do |klass|
          expect(klass.count).to eq(2)
          query = ApiModelQuery.new(data_source.metadata, ActionController::Parameters.new(f1: 'one,three'))
          expect(klass.search(query.generate_search_body_hash).count).to eq(2)
          query = ApiModelQuery.new(data_source.metadata, ActionController::Parameters.new(f2: 'two,five'))
          expect(klass.search(query.generate_search_body_hash).count).to eq(2)
        end
      end
    end
  end
end
