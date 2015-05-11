require 'spec_helper'

describe TradeArticle, type: :model do
  before(:all) do
    TradeArticle.recreate_index
    fixtures_file = "#{Rails.root}/spec/fixtures/trade_articles/trade_articles.json"
    TradeArticleData.new(fixtures_file).import
  end

  describe '.search_for' do
    it 'should return results sorted by pub_date' do
      ids = %w(447 446 501)
      expect(TradeArticle.search_for(update_date_start: '2013-01-01')[:hits].map { |h| h[:_id] }).to eq(ids)
    end

    context 'when options is an empty hash' do
      it 'finds all hits' do
        expect(TradeArticle.search_for({})[:total]).to eq(3)
      end
    end

    context 'when matching on title or content' do
      it 'uses fulltext search to finds relevant matches' do
        expect(TradeArticle.search_for(q: 'Marketing the Researcher')[:total]).to eq(1)
      end
    end

    context 'when filtering by evergreen field' do
      it 'finds just evergreen matches' do
        expect(TradeArticle.search_for(evergreen: 'true')[:total]).to eq(2)
        expect(TradeArticle.search_for(evergreen: 'false')[:total]).to eq(1)
      end
    end

    context 'when filtering on pub_date' do
      it 'finds articles published in that range' do
        expect(TradeArticle.search_for(pub_date_start: '2013-05-01', pub_date_end: '2013-05-14')[:total]).to eq(3)
        expect(TradeArticle.search_for(pub_date_start: '2013-05-14', pub_date_end: '2013-05-14')[:total]).to eq(1)
        expect(TradeArticle.search_for(pub_date_start: '2013-05-13')[:total]).to eq(1)
        expect(TradeArticle.search_for(pub_date_end: '2013-05-02')[:total]).to eq(2)
      end
    end

    context 'when filtering on update_date' do
      it 'finds articles published in that range' do
        expect(TradeArticle.search_for(update_date_start: '2013-05-01', update_date_end: '2013-06-12')[:total]).to eq(3)
        expect(TradeArticle.search_for(update_date_start: '2013-06-12', update_date_end: '2013-06-12')[:total]).to eq(1)
        expect(TradeArticle.search_for(update_date_start: '2013-05-13')[:total]).to eq(1)
        expect(TradeArticle.search_for(update_date_end: '2013-05-07')[:total]).to eq(2)
      end
    end
  end
end
