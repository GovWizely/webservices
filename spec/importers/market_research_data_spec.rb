require 'spec_helper'

describe MarketResearchData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/market_researches" }
  let(:resource) { "#{fixtures_dir}/market_researches.txt" }
  let(:importer) { MarketResearchData.new(resource) }

  it_behaves_like 'an importer which cannot purge old documents'

  describe '#import' do
    let(:entry_hash) { YAML.load_file("#{fixtures_dir}/market_researches.yaml") }

    it 'loads market research library from specified resource' do
      expect(MarketResearch).to receive(:index) do |entries|
        expect(entries.size).to eq(6)
        expect(entries[0]).to eq(entry_hash[0])
        expect(entries[1]).to eq(entry_hash[1])
        expect(entries[2]).to eq(entry_hash[2])
        expect(entries[3]).to eq(entry_hash[3])
        expect(entries[4]).to eq(entry_hash[4])
        expect(entries[5]).to eq(entry_hash[5])
      end
      importer.import
    end
  end
end
