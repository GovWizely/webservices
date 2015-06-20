require 'spec_helper'

describe TradeArticleData do
  let(:fixtures_dir) { "#{File.dirname(__FILE__)}/trade_article" }
  let(:fixtures_file) { "#{Rails.root}/spec/fixtures/trade_articles/trade_articles.json" }
  let(:importer) { TradeArticleData.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/trade_articles.yaml") }

  it_behaves_like 'an importer which cannot purge old documents'
  it_behaves_like 'an importer which versions resources'
  it_behaves_like 'an importer which indexes the correct documents'
end
