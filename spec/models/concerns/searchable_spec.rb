require 'spec_helper'

describe Searchable do
  before(:all) do
    class MockModel
      include Indexable
      analyze_by :snowball_asciifolding_nostop
      self.fetch_all_sort_by = 'foo'
      self.mappings = {
        name.typeize => {
          properties: {
            foo:         { type: 'keyword' },
            _updated_at: { type: 'date', format: 'strictDateOptionalTime' },
          },
        },
      }
      def self.source
        {
          full_name: 'A mocked model',
          code:      'MModel',
        }
      end
      self.model_classes = [MockModel]
    end

    class MockModelQuery
      def initialize(_options); end

      def self.sources
        [MockModel]
      end

      def search_type
        nil
      end

      def generate_search_body
        {}
      end

      def offset
        0
      end

      def size
        2
      end

      def sort
        []
      end
    end

    MockModel.recreate_index
    MockModel.index((1..1_000).map { |i| { foo: "Bar #{i}" } })
  end

  after(:all) do
    Object.send(:remove_const, :MockModel)
    Object.send(:remove_const, :MockModelQuery)
  end

  describe '#fetch_all' do
    subject { MockModel.fetch_all }

    it 'returns the correct number of documents' do
      expect(subject).to be_a(Hash)

      hits = subject[:hits]

      expect(hits.count).to eq(1_000)
      expect(hits.first[:_source]).to be_a(Hash)

      expect(hits.find { |h| h.key?(:time) }).to be_nil

      # Sorted correctly?
      expect(hits.first(10)).to eq hits.first(10).sort { |x, y| x[:_source][:foo] <=> y[:_source][:foo] }
    end

    it 'response includes metadata' do
      expect(subject.keys).to include(:search_performed_at)
      expect(subject[:search_performed_at]).to be_within(2).of(DateTime.now.utc)

      # too wide test for the description
      expect(subject.keys).to match_array([:total, :hits, :offset, :search_performed_at])
    end
  end

  describe '#search_for' do
    subject { MockModel.search_for({}) }

    it 'response includes metadata' do
      expect(subject.keys).to include(:search_performed_at)
      expect(subject[:search_performed_at]).to be_within(2).of(DateTime.now.utc)

      # too wide test for the description
      expect(subject.keys).to match_array([:total, :max_score, :hits, :offset, :search_performed_at, :aggregations])
    end
  end
end
