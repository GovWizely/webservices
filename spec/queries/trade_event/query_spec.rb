require 'spec_helper'

describe TradeEvent::Query do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/trade_events/" }

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
    before do
      allow(Date).to receive(:current).and_return(Date.parse('2013-10-07'))
    end

    context 'when options is an empty hash' do
      let(:query) { described_class.new }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_default_options.json").read }

      it 'generates search body with default options' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include industry' do
      let(:query) { described_class.new(industry: 'fishing') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_match_industries.json").read }

      it 'generates search body with queries' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include q' do
      let(:query) { described_class.new(q: 'workboat') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_multi_match.json").read }

      it 'generates search body with queries' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include countries' do
      let(:query) { described_class.new(countries: 'IL, US') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_filters.json").read }

      it 'generates search body with filters' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include start_date' do
      let(:query) { described_class.new(start_date: '2015-08-27 TO 2015-08-28') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_start_date.json").read }

      it 'generates search body with start_date filter' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include end_date_start or end_date_end' do
      let(:query) { described_class.new(end_date: '2015-08-27 TO 2015-08-28') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_end_date.json").read }

      it 'generates search body with end_date filter' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end
  end
end
