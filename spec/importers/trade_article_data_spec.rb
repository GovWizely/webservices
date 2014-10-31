require 'spec_helper'

describe TradeArticleData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/trade_articles" }
  let(:fixtures_file) { "#{fixtures_dir}/trade_articles.json" }
  let(:importer) { TradeArticleData.new(fixtures_file) }
  let(:trade_articles_hash) { YAML.load_file("#{fixtures_dir}/trade_articles.yaml") }

  it_behaves_like 'an importer which cannot purge old documents'

  describe '#import' do
    it 'loads trade articles from specified resource' do
      expect(TradeArticle).to receive(:index) do |trade_articles|
        expect(trade_articles.size).to eq(3)
        3.times { |x| expect(trade_articles[x]).to eq(trade_articles_hash[x]) }
      end
      importer.import
    end
  end
end
