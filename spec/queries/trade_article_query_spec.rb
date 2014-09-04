require 'spec_helper'

describe TradeArticleQuery do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/trade_articles" }

  describe '#new' do
    it_behaves_like 'a paginated query'

    describe 'evergreen' do
      context 'when options include evergreen as true' do
        subject { TradeArticleQuery.new(evergreen: 'true') }

        its(:evergreen) { should be_true }
      end
      context 'when options include evergreen as false' do
        subject { TradeArticleQuery.new(evergreen: 'false') }

        its(:evergreen) { should be_false }
      end
      context 'when options exclude evergreen' do
        subject { TradeArticleQuery.new({}) }

        its(:evergreen) { should be_nil }
      end
    end

    context 'when all options specified' do
      let(:some_date) { Date.parse('2013-10-17') }
      let(:query) { TradeArticleQuery.new({ q: 'some term', evergreen: 'true',
                                            pub_date_start: some_date, pub_date_end: some_date,
                                            update_date_start: some_date, update_date_end: some_date }) }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_all_params.json").read }

      it 'generates search body with all params' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

  end
end
