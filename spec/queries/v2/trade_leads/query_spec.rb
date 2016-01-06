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
end
