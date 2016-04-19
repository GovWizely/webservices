require 'spec_helper'

describe SalesforceArticle::FaqQuery do
  let(:fixtures_dir) { "#{File.dirname(__FILE__)}/query" }

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
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_default_options.json").read }

      it 'generates search body with default options' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include q' do
      let(:query) { described_class.new(q: 'elephants') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_multi_match.json").read }

      it 'generates search body with queries' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include industries' do
      let(:query) { described_class.new(industries: 'fishing') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_industries.json").read }

      it 'generates search body with industries filter' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include countries' do
      let(:query) { described_class.new(countries: 'IL,US') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_countries.json").read }

      it 'generates search body with countries filter' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include topics' do
      let(:query) { described_class.new(topics: 'government') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_topics.json").read }

      it 'generates search body with topics filter' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include trade_regions' do
      let(:query) { described_class.new(trade_regions: 'CAFTA-DR') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_trade_regions.json").read }

      it 'generates search body with trade_regions filter' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include world_regions' do
      let(:query) { described_class.new(world_regions: 'Asia,North America') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_world_regions.json").read }

      it 'generates search body with world_regions filter' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include first_pusblished_date' do
      let(:query) { described_class.new(first_published_date: '2016-01-01 TO 2016-08-28') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_first_published_date.json").read }

      it 'generates search body with first_published_date filter' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include last_published_date' do
      let(:query) { described_class.new(last_published_date: '2016-01-01 TO 2016-08-28') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_last_published_date.json").read }

      it 'generates search body with last_published_date filter' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end
  end
end
