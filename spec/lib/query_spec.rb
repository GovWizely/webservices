require 'spec_helper'

describe Query do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/base_query" }

  shared_context 'with MockChildQuery child class' do
    before(:each) do
      class MockChildQuery < Query
        setup_query(
          q:      %i(title description),
          query:  %i(),
          filter: %i(countries industries),
          sort:   %i(publish_date),
        )
      end
    end
  end

  describe '#generate_search_body' do
    context 'when setup_query all possible options' do
      include_context 'with MockChildQuery child class'
      let(:query) { MockChildQuery.new(q: 'workboat', countries: 'canada', industries: 'fishing') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_all.json").read }

      it 'generates search body with all the queries and filters' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end
  end

  describe '#valid_date_range?' do
    include_context 'with MockChildQuery child class'
    let(:query) { MockChildQuery.new }
    context 'when a date range is invalid' do
      it 'raises an exception' do
        expect { query.valid_date_range?('2015-01-1 TO 2015-12-31') }.to raise_error(Exceptions::InvalidDateRangeFormat)
      end
    end

    context 'when a date range is valid' do
      it 'executes without error' do
        expect(query.valid_date_range?('2015-01-01 TO 2015-12-31')).to eq(nil)
      end
    end
  end
end
