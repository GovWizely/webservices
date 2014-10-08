require 'spec_helper'

describe TradeEvent::UstdaQuery do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/trade_events/ustda" }

  describe '#new' do
    it_behaves_like 'a paginated query'

    context 'when options include countries' do
      subject { TradeEvent::UstdaQuery.new(countries: 'us,ca') }

      its(:countries) { should == %w(US CA) }
      its(:sort) { should == '_score,start_date' }
    end
  end

  describe '#generate_search_body' do
    before do
      Date.stub(:current).and_return(Date.parse('2013-10-07'))
    end

    context 'when options is an empty hash' do
      let(:query) { TradeEvent::UstdaQuery.new({}) }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_default_options.json").read }

      it 'generates search body with default options' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

    context 'when options include industry' do
      let(:query) { TradeEvent::UstdaQuery.new(industry: 'fishing') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_match_industries.json").read }

      it 'generates search body with queries' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

    context 'when options include q' do
      let(:query) { TradeEvent::UstdaQuery.new(q: 'workboat') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_multi_match.json").read }

      it 'generates search body with queries' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

    context 'when options include countries' do
      let(:query) { TradeEvent::UstdaQuery.new(countries: 'IL, US') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_filters.json").read }

      it 'generates search body with filters' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end
  end
end
