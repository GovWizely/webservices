require 'spec_helper'

describe Importer::DeletesOldDocuments do
  after do
    Object.send(:remove_const, :Mock)
    Object.send(:remove_const, :MockData)
  end

  describe 'error checks done by .prepended' do
    context 'when Importer has not been previously included' do
      it 'prevents inclusion' do
        expect do
          class Mock
          end
          class MockData
            prepend Importer::DeletesOldDocuments
          end
        end.to raise_error 'Must include Importer'
      end
    end

    context 'when related model does not extend Model::CanDeleteOldDocuments' do
      it 'prevents inclusion' do
        expect do
          class Mock
          end
          class MockData
            include Importer
            prepend Importer::DeletesOldDocuments
          end
        end.to raise_error 'model_class Mock must extend Model::CanDeleteOldDocuments'
      end
    end

    context 'with all pre-requisites met' do
      it 'allows inclusion' do
        expect do
          class Mock
            extend Indexable
            extend Model::CanDeleteOldDocuments
          end
          class MockData
            include Importer
            prepend Importer::DeletesOldDocuments
          end
        end.not_to raise_error
      end
    end
  end

  describe '#import' do
    describe 'basic functionality' do
      before do
        class Mock
          extend Indexable
          extend Model::CanDeleteOldDocuments
        end
        class MockData
          include Importer
          prepend Importer::DeletesOldDocuments
          def import
          end
        end
      end

      it 'sends :delete_old_documents to the model' do
        expect(Mock).to receive(:delete_old_documents)
        MockData.new.import
      end
    end

    describe 'called multiple times' do
      before do
        class Mock
          extend Indexable
          extend Model::CanDeleteOldDocuments
        end
        class MockData
          include Importer
          prepend Importer::DeletesOldDocuments
          def initialize(docs)
            @docs = docs
          end

          def import
            model_class.index(@docs)
          end
        end
      end

      let(:batch_1) do
        [{ 'id' => 1, 'content' => 'foo' },
         { 'id' => 2, 'content' => 'bar' }]
      end
      let(:batch_2) do
        [{ 'id' => 1, 'content' => 'foo [updated]' },
         { 'id' => 3, 'content' => 'baz' }]
      end
      let(:batch_3) do
        [{ 'id' => 3, 'content' => 'baz [updated]' }]
      end

      it 'does what it says on the tin' do
        MockData.new(batch_1).import
        sleep 0.1  # give ES some time between import and search
        expect(stored_docs).to match_array(batch_1)

        MockData.new(batch_2).import
        sleep 0.1
        expect(stored_docs).to match_array(batch_2)

        MockData.new(batch_3).import
        sleep 0.1
        expect(stored_docs).to match_array(batch_3)
      end

      def stored_docs
        ES.client.search(index: Mock.index_name)['hits']['hits'].map { |h| h['_source'] }
      end
    end

  end
end
