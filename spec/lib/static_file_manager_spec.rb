require 'spec_helper'

describe StaticFileManager do
  before(:all) do
    class ResponseDummy
      def initialize
      end

      def body
        StringIO.new('foo')
      end
    end

    class SearchClassDummy
      include SeparatedValuesable
      self.separated_values_config = [:foo, :bar]

      def self.fetch_all
        { hits: [{ _source: { foo: 'one', bar: 'two' } }] }
      end
    end
  end

  before(:each) do
    @s3 = instance_double(Aws::S3::Client)
    allow(Aws::S3::Client).to receive(:new).with(region: 'us-east-1', credentials: StaticFileManager::CREDENTIALS)
      .and_return(@s3,)
  end

  describe '#upload_all_files' do
    it 'uploads all format-type files to S3' do
      expect(@s3).to receive(:put_object).with(bucket: 'search-api-static-files', key: 'search_class_dummy.csv', body: "foo,bar\none,two\n")
      expect(@s3).to receive(:put_object).with(bucket: 'search-api-static-files', key: 'search_class_dummy.tsv', body: "foo\tbar\none\ttwo\n")
      described_class.upload_all_files(SearchClassDummy)
    end
  end

  describe '#download_file' do
    it 'downloads the correct file' do
      expect(@s3).to receive(:get_object).with(bucket: 'search-api-static-files', key: 'search_class_dummy.csv').and_return(ResponseDummy.new)
      expect(described_class.download_file('search_class_dummy.csv').body.read).to eq('foo')
    end
  end
end
