require 'spec_helper'

describe TariffRate::Query do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/tariff_rates" }

  describe '#new' do
    it_behaves_like 'a paginated query'

    context 'when options include countries' do
      subject { described_class.new(countries: 'us,au') }

      describe '#countries' do
        subject { super().countries }
        it { is_expected.to eq(%w(US AU)) }
      end
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
      let(:query) { described_class.new(sources: 'AUSTRALIA') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_sources_filter.json").read }

      it 'generates search body with sources filter' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include only countries' do
      let(:query) { described_class.new(countries: 'us,au') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_countries_filter.json").read }

      it 'generates search body with countries filter' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include all possible fields' do
      let(:query) do
        described_class.new(countries: 'us,au',
                            q:         'horses',
                            sources:   'AUSTRALIA')
      end
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_all.json").read }

      context 'when options include countries' do
        let(:query) { described_class.new(countries: 'US,AU') }
        let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_countries_filter.json").read }

        it 'generates search body with countries filter' do
          expect(JSON.parse(query.generate_search_body)).to eq(search_body)
        end
      end
    end
  end
end
