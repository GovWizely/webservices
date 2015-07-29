require 'spec_helper'

describe Searchable do
  describe '#fetch_all' do
    let(:index_name) { 'test_index_name' }
    let(:index_type) { 'test_index_type' }

    before do
      class MockModel
        include Searchable
        def self.index_names(_source = nil)
          ['test_index_name']
        end
        def self.index_types(_source = nil)
          ['test_index_type']
        end
      end

      # I'm doing this without the use of a class which includes Indexable
      # in order to only use Searchable in this spec.
      ES.client.indices.delete(index: index_name) if ES.client.indices.exists(index: index_name)
      1_000.times { |i| ES.client.index(index: index_name, type: index_type, body: { foo: "Bar #{i}" }) }

      ES.client.index(index: index_name, type: 'metadata', body: { time: Time.now })

      ES.client.indices.refresh(index: index_name)
    end

    after { Object.send(:remove_const, :MockModel) }

    subject { MockModel.fetch_all }

    it 'returns the correct number of documents' do
      expect(subject).to be_a(Hash)
      expect(subject[:hits].count).to eq(1_000)
      expect(subject[:hits].first[:_source]).to be_a(Hash)
      expect(subject[:hits].find { |h| h.key?(:time) }).to be_nil
    end
  end
end
