require 'spec_helper'

describe V2::MarketResearchQuery do
  let(:fixtures_dir) { "#{File.dirname(__FILE__)}/market_research" }

  describe '#new' do
    it_behaves_like 'a paginated query'

    context 'when options include countries' do
      let(:query) { described_class.new(countries: 'us,ca') }

      describe '#countries' do
        subject { query.countries }
        it { is_expected.to eq(%w(US CA)) }
      end
    end
  end

  describe '#generate_search_body' do
    context 'when options is an empty hash' do
      let(:query) { described_class.new }

      it 'generates search body with default options' do
        expect(JSON.parse(query.generate_search_body)).to eq({})
      end
    end

    context 'when options include industries' do
      let(:query) { described_class.new(industries: 'fishing, swimming') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_match_industries.json").read }

      it 'generates search body with queries' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include industry' do
      let(:query) { described_class.new(industry: 'fishing, swimming') }

      it 'should not be considered on the search' do
        expect(JSON.parse(query.generate_search_body)).to eq({})
      end
    end
  end
end
