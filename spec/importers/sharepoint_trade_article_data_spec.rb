require 'spec_helper'

describe SharepointTradeArticleData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/sharepoint_trade_articles" }
  let(:resource) { "#{fixtures_dir}/articles/*" }
  let(:importer) { SharepointTradeArticleData.new(resource) }

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
