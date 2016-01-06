require 'spec_helper'

describe DataSource do
  describe 'validations' do
    it do
      is_expected.to validate_presence_of(:name)
      is_expected.to validate_presence_of(:api)
      is_expected.to validate_presence_of(:data)
      is_expected.to validate_presence_of(:version_number)
      is_expected.to validate_numericality_of(:version_number)
    end

    ['foo bar', 'de-minimis', "loren's", 'Currencies'].each do |bad_value|
      it { is_expected.not_to allow_value(bad_value).for(:api) }
    end

    %w(market_researches parature_faq ita_office_locations country_commercial_guides business_service_providers ita_zip_codes ita_taxonomy eccn country_fact_sheets screening_lists tariff_rates trade_leads trade_events envirotech sharepoint_trade_articles trade_articles api_models).each do |existing_api|
      it { is_expected.not_to allow_value(existing_api).for(:api) }
    end

    %w(de_minimis_currencies area_51_residents).each do |ok_value|
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
    let(:data_source) { DataSource.create(_id: 'test_currencies:v1', published: true, version_number: 1, name: 'test', description: 'test API', api: 'test_currencies', data: "Country,ISO-2 code,de minimis value,de minimis currency,VAT amount,vatcurrency,date,Notes\r\nAndorra,AD,12,EUR,15.5,EUR,2015-10-01,\r\nArmenia,AM,150000,AMD,,,2015-10-02,some notes\r\n", dictionary: '') }

    before do
      data_source.ingest
      data_source.with_api_model do |klass|
        expect(klass.count).to eq(2)
        query = ApiModelQuery.new(data_source.metadata, ActionController::Parameters.new(country: 'Armenia'))
        expect(klass.search(query.generate_search_body_hash).first.iso2_code).to eq('AM')
        data_source.update(dictionary: "---\r\n:country_name:\r\n  :source: Country\r\n  :description: Description of Country\r\n  :indexed: true\r\n  :plural: false\r\n  :type: enum\r\n:iso_code:\r\n  :source: ISO-2 code\r\n  :description: Description of ISO-2 code\r\n  :indexed: true\r\n  :plural: true\r\n  :type: enum\r\n:de_minimis_value:\r\n  :source: de minimis value\r\n  :description: Description of de minimis value\r\n  :indexed: true\r\n  :plural: false\r\n  :type: integer\r\n:de_minimis_currency:\r\n  :source: de minimis currency\r\n  :description: Description of de minimis currency\r\n  :indexed: true\r\n  :plural: false\r\n  :type: enum\r\n:vat_amount:\r\n  :source: VAT amount\r\n  :description: Description of VAT amount\r\n  :indexed: true\r\n  :plural: false\r\n  :type: float\r\n:vat_currency:\r\n  :source: vatcurrency\r\n  :description: Description of VAT currency\r\n  :indexed: true\r\n  :plural: false\r\n  :type: enum\r\n:notes:\r\n  :source: Notes\r\n  :description: Description of Notes\r\n  :indexed: true\r\n  :plural: false\r\n  :type: string\r\n")
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
    end
  end

  describe 'search' do
    let(:data_source) { DataSource.create(_id: 'recall_and_relevancies:v4', published: true, version_number: 4, name: 'test', description: 'test API', api: 'recall_and_relevancies', data: "Country,ISO-2 code\r\nAndorra,AD\r\nArmenia,AM\r\nCanada,CA\r\n") }
    before do
      data_source.update(dictionary: "---\r\n:country_name:\r\n  :source: Country\r\n  :description: Description of Country\r\n  :indexed: true\r\n  :plural: false\r\n  :type: enum\r\n:iso2_code:\r\n  :source: ISO-2 code\r\n  :description: Description of ISO-2 code\r\n  :indexed: true\r\n  :plural: true\r\n  :type: enum\r\n")
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
    end
  end
end
