require 'spec_helper'

describe MarketResearchData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/market_researches" }
  let(:resource) { "#{fixtures_dir}/market_researches.txt" }
  let(:importer) { MarketResearchData.new(resource) }

  describe '#import' do
    let(:entry_hash) { YAML.load_file("#{fixtures_dir}/market_researches.yaml") }

    it 'loads market research library from specified resource' do
      MarketResearch.should_receive(:index) do |entries|
        entries.size.should == 6
        entries[0].should == entry_hash[0]
        entries[1].should == entry_hash[1]
        entries[2].should == entry_hash[2]
        entries[3].should == entry_hash[3]
        entries[4].should == entry_hash[4]
        entries[5].should == entry_hash[5]
      end
      importer.import
    end
  end
end
