require 'spec_helper'

describe V2::TradeLead::Query do
  let(:fixtures_dir) { "#{File.dirname(__FILE__)}/query" }

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
    context 'when option is an empty hash' do
      let(:query) { described_class.new }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_default_options.json").read }

      it 'generates search body with default options' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include industries' do
      let(:query) { described_class.new(industries: 'dental') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_industries_filter.json").read }

      it 'generates search body with industries filter' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end
  end

  context 'when options include only q' do
    let(:query) { described_class.new(q: 'women') }
    let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_q_search.json").read }

    it 'generates search body with q query' do
      expect(JSON.parse(query.generate_search_body)).to eq(search_body)
    end
  end

  context 'when options include trade_regions and world_regions' do
    let(:query) { described_class.new(trade_regions: 'European Union - 28', world_regions: 'Asia') }
    let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_geo_terms.json").read }

    it 'generates search body with q query' do
      expect(JSON.parse(query.generate_search_body)).to eq(search_body)
    end
  end

  context 'when q includes a country term that must be parsed' do
    let(:query) { described_class.new(q: 'trade with china') }
    let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_parsed_country.json").read }
    let(:taxonomy_results) { YAML.load_file("#{Rails.root}/spec/models/ita_taxonomy/related_term_results.yaml") }

    it 'generates search body with parsed query' do
      allow(ItaTaxonomy).to receive(:search_related_terms).and_return([taxonomy_results.first])
      expect(JSON.parse(query.generate_search_body)).to eq(search_body)
    end
  end

  context 'when q includes only a world region term that must be parsed' do
    let(:query) { described_class.new(q: 'north america') }
    let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_parsed_world_region.json").read }
    let(:taxonomy_results) { YAML.load_file("#{Rails.root}/spec/models/ita_taxonomy/related_term_results.yaml") }

    it 'generates search body with parsed query' do
      allow(ItaTaxonomy).to receive(:search_related_terms).and_return([taxonomy_results[1]])
      expect(JSON.parse(query.generate_search_body)).to eq(search_body)
    end
  end
end
