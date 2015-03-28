require 'spec_helper'

describe TariffRate::Query do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/tariff_rates" }

  describe '#new' do
    it_behaves_like 'a paginated query'

    context 'when options include sources' do
      subject { described_class.new(sources: 'us,au').sources }
      it { is_expected.to eq(%w(US AU)) }
    end
  end

  describe '#generate_search_body' do

    context 'when options include only q' do
      let(:query) { described_class.new(q: 'horses') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_multi_match.json").read }

      it 'generates search body with q query' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include only sources' do
      let(:query) { described_class.new(sources: 'us,au') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_sources_filter.json").read }

      it 'generates search body with sources filter' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include sources and q' do
      let(:query) do
        described_class.new(sources: 'us,au',
                            q:       'horses')
      end
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_all.json").read }
      it 'generates search body with all possible filters' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include only final_year' do
      let(:query) { described_class.new(final_year: '2014 TO 2015') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_final_year.json").read }

      it 'generates search body with sources filter' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include only partner_start_year' do
      let(:query) { described_class.new(partner_start_year: '2014 TO 2015') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_partner_start_year.json").read }

      it 'generates search body with sources filter' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include only reporter_start_year' do
      let(:query) { described_class.new(reporter_start_year: '2014 TO 2015') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_reporter_start_year.json").read }

      it 'generates search body with sources filter' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

  end
end
