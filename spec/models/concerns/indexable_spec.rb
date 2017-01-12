require 'spec_helper'

shared_context 'a working Mock model class' do
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
    end
  end
end

describe Indexable do
  after { Object.send(:remove_const, :Mock) }

  describe '.prepare_record_for_indexing' do
    context 'given a record with _updated_at settings' do
      include_context 'a working Mock model class'
      let(:now) { Time.now.utc.iso8601(8) }

      let(:record) do
        { foo:         'bar',
          yin:         'yang',
          _updated_at: now,
          id:          1337, }
      end
      subject { Mock.send(:prepare_record_for_indexing, record) }

      it do
        is_expected.to match(body:  { foo: 'bar', yin: 'yang', _updated_at: now },
                             id:    1337,
                             index: 'test:webservices:mocks',
                             type:  :mock,)
      end
    end
  end

  describe '.can_purge_old?' do
    context 'with a model that has a _updated_at mapping' do
      include_context 'a working Mock model class'
      subject { Mock.can_purge_old? }
      it { is_expected.to be_truthy }
    end

    context 'with a model that does not have a _updated_at mapping' do
      before do
        class Mock
          include Indexable
          analyze_by :snowball_asciifolding_nostop
          self.mappings = { name.typeize => { properties: {} } }
        end
      end
      subject { Mock.can_purge_old? }
      it { is_expected.to be_falsey }
    end
  end

  describe '.purge_old' do
    include_context 'a working Mock model class'
    before do
      Mock.recreate_index
      Mock.index(docs_to_index)
    end

    let(:docs_to_index) do
      [{ title: 'foo', _updated_at: 2.days.ago },
       { title: 'bar' },]
    end
    let(:docs_expected) do
      [{ 'title' => 'foo' },
       { 'title' => 'bar' },]
    end

    let(:search) { ES.client.search(index: Mock.index_name, type: Mock.index_type) }

    subject(:total) { search['hits']['total'] }
    subject(:docs_retrieved) do
      search['hits']['hits'].map { |h| h['_source'] }
    end

    context 'with date arg earlier than oldest doc' do
      before { Mock.purge_old(3.days.ago) }
      it 'does not purge any documents' do
        expect(total).to eq 2
        expect(docs_retrieved).to match_array([a_hash_including(docs_expected.first), a_hash_including(docs_expected.last)])
      end
    end

    context "with date arg between the two docs' timestamps" do
      before { Mock.purge_old(1.day.ago) }
      it 'purges only the oldest doc' do
        expect(total).to eq 1
        expect(docs_retrieved).to match_array([a_hash_including(docs_expected.last)])
      end
    end

    context 'with date arg later than newest doc' do
      before { Mock.purge_old(1.second.from_now) }
      it 'purges all documents' do
        expect(total).to eq 0
        expect(docs_retrieved).to eq([])
      end
    end
  end

  describe '.importer_class' do
    include_context 'a working Mock model class'
    subject { Mock.importer_class }
    it { is_expected.to eq(MockData) }
  end

  describe '.create_index' do
    include_context 'a working Mock model class'
    before { Mock.recreate_index }
    it 'creates metadata' do
      m = Mock.stored_metadata
      expect(m.keys).to match_array %i(last_imported last_updated version import_rate)
    end
    it 'sets last_imported to empty string' do
      last_imported_time = Mock.stored_metadata[:last_imported]
      expect(last_imported_time).to eq('')
    end
  end
end
