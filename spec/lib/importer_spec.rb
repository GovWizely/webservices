require 'spec_helper'

describe Importer do
  before do
    class Mock
      extend Indexable
      self.mappings = {
        name.typeize => {
          _timestamp: {
            enabled: true,
            store:   true,
          },
        },
      }
    end

    class MockData
      include Importer
      def initialize(docs = nil)
        @docs = docs
      end

      def import
        model_class.index(@docs)
      end
    end

    class MockQuery < Query
      def generate_search_body
        {}
      end
    end

    Mock.recreate_index
  end

  after do
    Object.send(:remove_const, :Mock)
    Object.send(:remove_const, :MockData)
  end

  describe '#lookup_country' do
    it 'finds alpha2 code' do
      country_names = ['burma (Myanmar)',
                       "cote d'Ivoire",
                       'congo, Democratic Rep. of the',
                       'congo, Republic of the',
                       'Democratic Republic of Congo',
                       'korea (South)',
                       'kosovo',
                       'Republic of the Congo',
                       'São Tomé & Príncipe',
                       'south Korea',
                       'St. Lucia',
                       'vietnam']
      country_names.each do |country_name|
        expect(MockData.new.lookup_country(country_name)).not_to be_nil
      end
    end
  end

  describe '#parse_date' do
    subject { MockData.new.parse_date(date_str) }

    context 'when given a parsable string' do
      let(:date_str) { '20 May 1954' }
      it { is_expected.to eq '1954-05-20' }
    end

    context 'when given an ambiguous date string' do
      let(:date_str) { '5/6/1999' }
      it { is_expected.to eq '1999-06-05' }
    end

    context 'when given a non-parsable string' do
      let(:date_str) { 'not a date' }
      it { is_expected.to be_nil }
    end
  end

  describe '#parse_american_date' do
    subject { MockData.new.parse_american_date(date_str) }

    context 'when given a parsable string' do
      let(:date_str) { '5/6/1999' }
      it { is_expected.to eq '1999-05-06' }
    end

    context 'when given a non-parsable string' do
      let(:date_str) { 'not a date' }
      it { is_expected.to be_nil }
    end
  end

  describe '#sanitize_entry' do
    subject { MockData.new.sanitize_entry(hash) }
    let(:hash) { { one: nil, two: ' ', three: ' f ', four: 'o', five: [' o', 'b '] } }
    it { is_expected.to eq(one: nil, two: nil, three: 'f', four: 'o', five: [' o', 'b ']) }

    context 'with HTML in field values' do
      let(:hash) { { one: '<p id="one">One...</p>', two: ' &amp; two' } }
      it { is_expected.to eq(one: 'One...', two: '& two') }
    end
  end

  describe '#model_class' do
    subject { MockData.new.model_class }
    it { is_expected.to eq Mock }
  end

  describe '#import_then_purge_old' do
    let(:batch_1) do
      [{ id: 1, content: 'foo' },
       { id: 2, content: 'bar' }]
    end
    let(:batch_2) do
      [{ id: 1, content: 'foo [updated]' },
       { id: 3, content: 'baz' }]
    end
    let(:batch_3) do
      [{ id: 3, content: 'baz [updated]' }]
    end

    it 'purges correct documents' do
      MockData.new(batch_1).import_then_purge_old
      expect(stored_docs).to match_array(batch_1.map { |d| d.except(:id) })

      MockData.new(batch_2).import_then_purge_old
      expect(stored_docs).to match_array(batch_2.map { |d| d.except(:id) })

      MockData.new(batch_3).import_then_purge_old
      expect(stored_docs).to match_array(batch_3.map { |d| d.except(:id) })
    end

    def stored_docs
      Mock.search_for({})[:hits].map { |h| h['_source'].deep_symbolize_keys }
    end
  end
end
