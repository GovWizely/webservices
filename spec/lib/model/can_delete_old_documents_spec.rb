require 'spec_helper'

describe Model::CanDeleteOldDocuments do
  shared_context 'a working Mock model class' do
    before do
      class Mock
        extend Indexable
        extend Model::CanDeleteOldDocuments
      end
    end
  end

  after do
    Object.send(:remove_const, :Mock)
  end

  describe 'error checks done by .extended' do
    context 'when class has not been extended by Indexable' do
      it 'prevents inclusion' do
        expect do
          class Mock
            extend Model::CanDeleteOldDocuments
          end
        end.to raise_error 'Mock must be extended by Indexable'
      end
    end

    context 'with all pre-requisites met' do
      it 'allows inclusion' do
        expect do
          class Mock
            extend Indexable
            extend Model::CanDeleteOldDocuments
          end
        end.not_to raise_error
      end
    end
  end

  describe '.mappings' do
    include_context 'a working Mock model class'

    subject { Mock.mappings[Mock.to_s.typeize] }
    it 'contains the _timestamp key' do
      expect(subject['_timestamp']).to eq('enabled' => true,
                                          'store'   => true)
    end
  end

  describe '#delete_old_documents' do
    include_context 'a working Mock model class'

    before do
      Mock.recreate_index
      Mock.index(docs_to_index)
    end

    let(:docs_to_index) do
      [{ title: 'foo', _timestamp: 2.days.ago.to_i * 1000 },
       { title: 'bar' }]
    end
    let(:docs_expected) do
      [{ 'title' => 'foo' },
       { 'title' => 'bar' }]
    end

    let(:search) { ES.client.search(index: Mock.index_name) }

    subject(:total) { search['hits']['total'] }
    subject(:docs_retrieved) do
      search['hits']['hits'].map { |h| h['_source'] }
    end

    context 'with date arg earlier than oldest doc' do
      before { Mock.delete_old_documents(3.days.ago) }
      it 'does not delete any documents' do
        expect(total).to eq 2
        expect(docs_retrieved).to match_array(docs_expected)
      end
    end

    context "with date arg between the two docs' timestamps" do
      before { Mock.delete_old_documents(1.day.ago) }
      it 'deletes only the oldest doc' do
        expect(total).to eq 1
        expect(docs_retrieved).to eq([docs_expected[1]])
      end
    end

    context 'with date arg later than newest doc' do
      before { Mock.delete_old_documents(Time.now) }
      it 'deletes all documents' do
        expect(total).to eq 0
        expect(docs_retrieved).to eq([])
      end
    end
  end
end
