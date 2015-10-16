require 'spec_helper'

describe MarketResearchData, vcr: { cassette_name: 'importers/market_research.yml', record: :once } do
  let(:resource) { "#{Rails.root}/spec/fixtures/market_research/source.txt" }
  let(:importer) { MarketResearchData.new(resource) }
  let(:expected) { YAML.load_file("#{File.dirname(__FILE__)}/market_research/expected_indexed_data.yaml") }

  it_behaves_like 'an importer which cannot purge old documents'
  it_behaves_like 'an importer which indexes the correct documents'
end
