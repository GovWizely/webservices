shared_context 'MarketResearch data' do
  before(:all) do
    MarketResearch.recreate_index
    VCR.use_cassette('importers/market_research.yml', record: :once) do
      MarketResearchData.new("#{Rails.root}/spec/fixtures/market_research/source.txt").import
    end
  end
end
