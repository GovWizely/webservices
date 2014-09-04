require 'spec_helper'

describe TradeArticleData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/trade_articles" }
  let(:fixtures_file) { "#{fixtures_dir}/trade_articles.json" }
  let(:importer) { TradeArticleData.new(fixtures_file) }
  let(:trade_articles_hash) { YAML.load_file("#{fixtures_dir}/trade_articles.yaml") }

  describe '#import' do
    it 'loads trade articles from specified resource' do
      TradeArticle.should_receive(:index) do |trade_articles|
        trade_articles.size.should == 3
        3.times { |x| trade_articles[x].should == trade_articles_hash[x] }
      end
      importer.import
    end
  end
end
