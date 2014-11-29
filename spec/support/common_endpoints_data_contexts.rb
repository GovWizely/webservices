shared_context 'SharepointTradeArticle data' do
  before(:all) do
    SharepointTradeArticle.recreate_index
    VCR.use_cassette("SharepointTradeArticleData/_import/loads_sharepoint_trade_articles_from_specified_resource", :record => :new_episodes) do
      SharepointTradeArticleData.new("#{Rails.root}/spec/fixtures/sharepoint_trade_articles/articles/*").import
    end
  end
end

shared_context 'TradeArticle data' do
  before(:all) do
    TradeArticle.recreate_index
    fixtures_file = "#{Rails.root}/spec/fixtures/trade_articles/trade_articles.json"
    VCR.use_cassette("TradeArticleData/_import/loads_trade_articles_from_specified_resource", :record => :new_episodes) do
      TradeArticleData.new(fixtures_file).import
    end
  end
end


shared_context 'Parature FAQ data' do 
  before(:all) do
    ParatureFaq.recreate_index
    VCR.use_cassette("ParatureFaqData/_import/loads_parature_faqs_from_specified_resource", :record => :new_episodes) do
      ParatureFaqData.new("#{Rails.root}/spec/fixtures/parature_faqs/articles/article%d.xml").import
    end
  end
end

shared_context 'MarketResearch data' do 
  before(:all) do
    MarketResearch.recreate_index
    VCR.use_cassette("MarketResearchData/_import/loads_market_research_library_from_specified_resource", :record => :new_episodes) do
      MarketResearchData.new("#{Rails.root}/spec/fixtures/market_researches/market_researches.txt").import
    end
  end
end