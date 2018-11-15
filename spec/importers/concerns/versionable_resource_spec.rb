require 'spec_helper'

describe VersionableResource do
  before do
    class Mock
      include Indexable
      analyze_by :snowball_asciifolding_nostop
      self.mappings = {
        name.typeize => {
          properties: {
            _updated_at: { type: 'date', format: 'strictDateOptionalTime' },
          },
        },
      }
    end

    class MockData
      include Importable
      include VersionableResource
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

  describe '#import' do
    it 'stores the data' do
      MockData.new([{ id: 1, content: 'foo' }]).import
    end

    describe 'resource-versioning logic' do
      it 're-indexes different data' do
        expect(Mock).to receive(:index).twice
        MockData.new([{ id: 1, content: 'foo' }]).import
        MockData.new([{ id: 2, content: 'bar' }]).import
      end

      it 're-indexes identical data' do
        expect(Mock).to receive(:index).twice
        MockData.new([{ id: 1, content: 'foo' }]).import
        MockData.new([{ id: 1, content: 'foo' }]).import
      end
    end
  end
end
