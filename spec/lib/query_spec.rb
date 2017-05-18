require 'spec_helper'

describe Query, type: :model do
  shared_context 'with MockChildQuery child class' do
    before do
      class MockChildQuery < Query
        setup_query(
          q:      %i(title description),
          query:  %i(),
          filter: %i(countries industries),
          sort:   %i(publish_date),
        )
      end
    end
    after { Object.send(:remove_const, :MockChildQuery) }
  end

  describe 'validations' do
    it do
      is_expected.to validate_numericality_of(:offset)
        .is_greater_than_or_equal_to(0,)
        .allow_nil
    end
  end

  describe '#new' do
    context 'when given an invalid offset' do
      let(:offset) { -50 }
      subject { described_class.new(offset: offset) }
      it 'raises an InvalidParamsException' do
        expect { subject }.to raise_error(Query::InvalidParamsException)
      end
    end
    context 'when given an empty parameter' do
      before do
        class TestWithSetupQuery < Query
          attr_accessor :countries

          def initialize(options = {})
            super
            @countries = options[:countries] if options[:countries].present?
          end

          setup_query(
            q:     %i(title description),
            query: %i(q),
          )
        end
      end
      after do
        Object.send(:remove_const, :TestWithSetupQuery)
      end
      subject {}
      it 'should behave like no :q parameter was passed' do
        expect(TestWithSetupQuery.new(q: '').q).to be_nil
      end
      it 'should behave like no :q parameter was passed2' do
        expect(ScreeningList::Query.new(q: '').q).to be_nil
      end
      it 'should behave like no :countries parameter was passed' do
        expect(TestWithSetupQuery.new(countries: '').countries).to be_nil
      end
    end
  end

  describe '#generate_search_body' do
    context 'setup_query contains all possible options' do
      include_context 'with MockChildQuery child class'
      let(:query) do
        MockChildQuery.new(q: 'scuba in cuba and asia', countries: 'canada', industries: 'fishing')
      end
      let(:search_body) { JSON.parse open("#{File.dirname(__FILE__)}/query/search_body_with_all.json").read }

      it 'generates search body with all the queries and filters' do
        puts JSON.parse(query.generate_search_body)
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end
  end

  describe '#valid_date_range?' do
    include_context 'with MockChildQuery child class'

    subject { MockChildQuery.new.valid_date_range?(range) }

    shared_examples 'a query that was given an invalid date range' do
      it 'raises an InvalidDateRangeFormat error' do
        expect { subject }.to raise_error(Exceptions::InvalidDateRangeFormat)
      end
    end

    shared_examples 'a query that was given a valid date range' do
      it { is_expected.to be_truthy }
    end

    context 'when date has month but no day' do
      let(:range) { '2015-01 TO 2015-12-31' }
      it_behaves_like 'a query that was given an invalid date range'
    end

    context 'when one of the dates has correct format but is not an actual date' do
      let(:range) { '2015-01-32 TO 2015-02-01' }
      it_behaves_like 'a query that was given an invalid date range'
    end

    context "when range doesn't contain any obvious dates" do
      let(:range) { 'monkey' }
      it_behaves_like 'a query that was given an invalid date range'
    end

    context 'when range has dates that are not in YYYY-MM-DD format' do
      let(:range) { '3 Apr 2013 TO 4 Apr 2013' }
      it_behaves_like 'a query that was given an invalid date range'
    end

    context 'when range contains two YYYY-MM-DD dates' do
      let(:range) { '2015-01-01 TO 2015-12-31' }
      it_behaves_like 'a query that was given a valid date range'
    end

    context 'when range contains two YYYY years' do
      let(:range) { '2015 TO 2016' }
      it_behaves_like 'a query that was given a valid date range'
    end
  end

  describe '#parse_sort_parameter' do
    include_context 'with MockChildQuery child class'

    subject { MockChildQuery.new(sort: '_score,publish_date:desc') }

    it 'builds the correct query when provided a sort param' do
      expect(subject.sort).to eq(['_score', { 'publish_date' => 'desc' }])
    end
  end
end
