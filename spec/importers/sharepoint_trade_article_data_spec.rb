require 'spec_helper'

describe SharepointTradeArticleData do

  fixtures_dir = "#{File.dirname(__FILE__)}/sharepoint_trade_article"
  fixtures_files = Dir["#{Rails.root}/spec/fixtures/sharepoint_trade_articles/articles/*"].map { |file| open(file) }

  s3 = stubbed_s3_client('sharepoint_trade_article')
  s3.stub_responses(:list_objects, contents: [{ key: '116.xml' }, { key: '117.xml' }, { key: '118.xml' }, { key: '119.xml' }])
  s3.stub_responses(:get_object, { body: fixtures_files[0] }, { body: fixtures_files[1] }, { body: fixtures_files[2] }, body: fixtures_files[3])

  let(:importer) { SharepointTradeArticleData.new(s3) }

  describe '#import' do
    let(:entry_hash) { YAML.load_file("#{fixtures_dir}/results.yaml") }

    it 'loads sharepoint trade articles from specified resource' do
      expect(SharepointTradeArticle).to receive(:index) do |entries|

        expect(entries.size).to eq(4)
        expect(entries).to match_array entry_hash

      end
      importer.import
    end
  end
end
