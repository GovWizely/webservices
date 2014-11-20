require 'spec_helper'

describe TradeLead::Query do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/trade_leads" }

  describe '#new' do
    it_behaves_like 'a paginated query'

    context 'when options include countries' do
      let(:query) { described_class.new(countries: 'ca,au') }

      describe '#countries' do
        subject { query.countries }
        it { is_expected.to eq(%w(CA AU)) }
      end
    end
  end

  describe '#generate_search_body' do

    context 'when options are empty' do
      let(:query) { described_class.new }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_default_options.json").read }

      it 'generates search body with q query' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include only q' do
      let(:query) { described_class.new(q: 'women') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_multi_match.json").read }

      it 'generates search body with q query' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include only sources' do
      let(:query) { described_class.new(sources: 'FBO') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_sources_filter.json").read }

      it 'generates search body with sources filter' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include only countries' do
      let(:query) { described_class.new(countries: 'ca,au') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_country_filter.json").read }

      it 'generates search body with countries filter' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include industries' do
      let(:query) { described_class.new(industries: 'dental') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_industries_query.json").read }

      it 'generates search body with countries filter' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include all possible fields' do
      let(:query) do
        described_class.new(countries:  'ca,au',
                            q:          'women',
                            industries: 'dental',
                            sources:    'FBO')
      end
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_all_query_filter.json").read }
      it 'generates search body with countries filter' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end
  end
end
