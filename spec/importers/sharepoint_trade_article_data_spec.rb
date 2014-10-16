require 'spec_helper'

describe SharepointTradeArticleData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/sharepoint_trade_articles" }
  let(:resource) { "#{fixtures_dir}/articles/%d.xml" }
  let(:importer) { SharepointTradeArticleData.new(resource) }

  describe '#import' do
    let(:entry_hash) { YAML.load_file("#{fixtures_dir}/results.yaml") }

    it 'loads sharepoint trade articles from specified resource' do
      SharepointTradeArticle.should_receive(:index) do |entries|

        entries.size.should == 4
        entries.should match_array entry_hash

      end
      importer.import
    end
  end
end