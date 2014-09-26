require 'spec_helper'

describe TradeArticle do
  before(:all) do
    TradeArticle.recreate_index
    fixtures_file = "#{Rails.root}/spec/fixtures/trade_articles/trade_articles.json"
    TradeArticleData.new(fixtures_file).import
  end

  describe '.search_for' do

    it 'should return results sorted by pub_date' do
      ids = %w(447 446 501)
      TradeArticle.search_for(update_date_start: '2013-01-01')[:hits].map { |h| h['_id'] }.should == ids
    end

    context 'when options is an empty hash' do
      it 'finds all hits' do
        TradeArticle.search_for({})[:total].should == 3
      end
    end

    context 'when matching on title or content' do
      it 'uses fulltext search to finds relevant matches' do
        TradeArticle.search_for(q: 'Marketing the Researcher')[:total].should == 1
      end
    end

    context 'when filtering by evergreen field' do
      it 'finds just evergreen matches' do
        TradeArticle.search_for(evergreen: 'true')[:total].should == 2
        TradeArticle.search_for(evergreen: 'false')[:total].should == 1
      end
    end

    context 'when filtering on pub_date' do
      it 'finds articles published in that range' do
        TradeArticle.search_for(pub_date_start: '2013-05-01', pub_date_end: '2013-05-14')[:total].should == 3
        TradeArticle.search_for(pub_date_start: '2013-05-14', pub_date_end: '2013-05-14')[:total].should == 1
        TradeArticle.search_for(pub_date_start: '2013-05-13')[:total].should == 1
        TradeArticle.search_for(pub_date_end: '2013-05-02')[:total].should == 2
      end
    end

    context 'when filtering on update_date' do
      it 'finds articles published in that range' do
        TradeArticle.search_for(update_date_start: '2013-05-01', update_date_end: '2013-06-12')[:total].should == 3
        TradeArticle.search_for(update_date_start: '2013-06-12', update_date_end: '2013-06-12')[:total].should == 1
        TradeArticle.search_for(update_date_start: '2013-05-13')[:total].should == 1
        TradeArticle.search_for(update_date_end: '2013-05-07')[:total].should == 2
      end
    end

  end
end
