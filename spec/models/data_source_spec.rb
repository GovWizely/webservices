require 'spec_helper'

describe DataSource do
  describe 'validations' do
    it do
      is_expected.to validate_presence_of(:name)
      is_expected.to validate_presence_of(:api)
      is_expected.to validate_presence_of(:data)
    end
  end

  describe 'lifecycle callbacks' do
    let(:data_source) { DataSource.new(_id: 'some_things', name: 'test', description: 'test API', api: 'some_things', data: 'CSV as String') }

    before do
      parser = instance_double(DataSourceParser, generate_dictionary: { field1: 'foo', field2: 'bar' })
      expect(DataSourceParser).to receive(:new).with('CSV as String').and_return parser
      data_source.save
    end

    describe 'saving a data source' do
      it 'builds the data dictionary based on the uploaded CSV data' do
        expect(data_source.dictionary).to eq("---\n:field1: foo\n:field2: bar\n")
      end
    end

    describe 'destroying a data source' do
      it 'deletes the API index in Elasticsearch' do
        expect(ES.client.indices).to receive(:delete).with(index: 'test:webservices:api_models:some_things', ignore: 404)
        data_source.destroy
      end
    end
  end

  describe 'ingest' do
    let(:data_source) { DataSource.create(_id: 'test_currencies', name: 'test', description: 'test API', api: 'test_currencies', data: "Country,ISO-2 code,de minimis value,de minimis currency,VAT amount,VAT currency,date,Notes\r\nAndorra,AD,12,EUR,15.5,,2015-10-01,\r\nArmenia,AM,150000,AMD,,,2015-10-02,\r\n", dictionary: "---\r\n:country:\r\n  :source: Country\r\n  :description: Description of Country\r\n  :indexed: true\r\n  :type: enum\r\n:iso2_code:\r\n  :source: ISO-2 code\r\n  :description: Description of ISO-2 code\r\n  :indexed: true\r\n  :type: enum\r\n:de_minimis_value:\r\n  :source: de minimis value\r\n  :description: Description of de minimis value\r\n  :indexed: true\r\n  :type: integer\r\n:de_minimis_currency:\r\n  :source: de minimis currency\r\n  :description: Description of de minimis currency\r\n  :indexed: false\r\n  :type: enum\r\n:vat_amount:\r\n  :source: VAT amount\r\n  :description: Description of VAT amount\r\n  :indexed: true\r\n  :type: float\r\n:vat_currency:\r\n  :source: VAT currency\r\n  :description: Description of VAT currency\r\n  :indexed: true\r\n  :type: enum\r\n:date:\r\n  :source: date\r\n  :description: Description of date\r\n  :indexed: true\r\n  :type: date\r\n:notes:\r\n  :source: Notes\r\n  :description: Description of Notes\r\n  :indexed: true\r\n  :type: string\r\n") }

    before do
      data_source.ingest
      data_source.with_api_model do |klass|
        expect(klass.count).to eq(2)
        expect(klass.search(filter: { term: { country: 'Armenia' } }).first.iso2_code).to eq('AM')
        data_source.update(dictionary: "---\r\n:country_name:\r\n  :source: Country\r\n  :description: Description of Country\r\n  :indexed: true\r\n  :type: enum\r\n:iso2_code:\r\n  :source: ISO-2 code\r\n  :description: Description of ISO-2 code\r\n  :indexed: true\r\n  :type: enum\r\n:de_minimis_value:\r\n  :source: de minimis value\r\n  :description: Description of de minimis value\r\n  :indexed: true\r\n  :type: integer\r\n:de_minimis_currency:\r\n  :source: de minimis currency\r\n  :description: Description of de minimis currency\r\n  :indexed: false\r\n  :type: enum\r\n:vat_amount:\r\n  :source: VAT amount\r\n  :description: Description of VAT amount\r\n  :indexed: true\r\n  :type: float\r\n:vat_currency:\r\n  :source: VAT currency\r\n  :description: Description of VAT currency\r\n  :indexed: true\r\n  :type: enum\r\n:date:\r\n  :source: date\r\n  :description: Description of date\r\n  :indexed: true\r\n  :type: date\r\n:notes:\r\n  :source: Notes\r\n  :description: Description of Notes\r\n  :indexed: true\r\n  :type: string\r\n")
      end
      data_source.ingest
    end

    it 'creates entries in the new api index with the new class constant' do
      results = data_source.with_api_model do |klass|
        klass.search(filter: { term: { country_name: 'Armenia' } })
      end
      expect(results.first.iso2_code).to eq('AM')
      expect(Webservices::ApiModels.constants).to include(:TestCurrency)
    end
  end
end
