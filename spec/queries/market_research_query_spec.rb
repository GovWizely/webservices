require 'spec_helper'

describe MarketResearchQuery do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/market_researches" }

  describe '#new' do
    it_behaves_like 'a paginated query'

    context 'when options include countries' do
      subject { MarketResearchQuery.new(countries: 'us,ca') }

      describe '#countries' do
        subject { super().countries }
        it { is_expected.to eq(%w(US CA)) }
      end
    end
  end

  describe '#generate_search_body' do
    context 'when options is an empty hash' do
      let(:query) { MarketResearchQuery.new({}) }

      it 'generates search body with default options' do
        expect(JSON.parse(query.generate_search_body)).to eq({})
      end
    end

    context 'when options include industry' do
      let(:query) { MarketResearchQuery.new(industry: 'fishing') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_match_industries.json").read }

      it 'generates search body with queries' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include q' do
      let(:query) { MarketResearchQuery.new(q: 'workboat') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_multi_match.json").read }

      it 'generates search body with queries' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include countries' do
      let(:query) { MarketResearchQuery.new(countries: 'IL, US') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_filters.json").read }

      it 'generates search body with filters' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end
  end
end
