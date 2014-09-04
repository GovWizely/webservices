require 'spec_helper'

describe ItaTradeEventQuery do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/ita_trade_events" }

  describe '#new' do
    it_behaves_like 'a paginated query'

    context 'when options include countries' do
      subject { described_class.new(countries: 'us,ca') }

      its(:countries) { should == %w(US CA) }
    end
  end

  describe '#generate_search_body' do
    before do
      Date.stub(:current).and_return(Date.parse('2013-10-07'))
    end

    context 'when options is an empty hash' do
      let(:query) { described_class.new({}) }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_default_options.json").read }

      it 'generates search body with default options' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

    context 'when options include industry' do
      let(:query) { described_class.new(industry: 'fishing') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_match_industries.json").read }

      it 'generates search body with queries' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

    context 'when options include q' do
      let(:query) { described_class.new(q: 'workboat') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_multi_match.json").read }

      it 'generates search body with queries' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

    context 'when options include countries' do
      let(:query) { described_class.new(countries: 'IL, US') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_filters.json").read }

      it 'generates search body with filters' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end
  end
end