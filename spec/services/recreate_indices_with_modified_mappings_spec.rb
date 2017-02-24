require 'spec_helper'

shared_context 'with an adjusted ItaTaxonomy.mappings' do
  let(:model) { ItaTaxonomy }
  before do
    @original_mappings = model.mappings.deep_dup
    model.mappings[model.index_type][:properties][:label][:analyzer] = 'keyword'
  end
  after do
    model.mappings = @original_mappings
    model.recreate_index
  end
end

describe RecreateIndicesWithModifiedMappings do
  before(:all) { Webservices::Application.model_classes.each(&:recreate_index) }

  describe '.call' do
    include_context 'with an adjusted ItaTaxonomy.mappings'

    it 'recreates and imports necessary indices' do
      expect(described_class.model_classes_which_need_recreating).to eq([model])
      expect(ImportWorker).to receive(:perform_async).with(model.importer_class.name)

      described_class.call

      expect(described_class.model_classes_which_need_recreating).to be_empty
    end
  end

  describe '.model_classes_which_need_recreating' do
    subject { described_class.model_classes_which_need_recreating }

    context 'when all model mappings are the same as DB' do
      it { is_expected.to be_empty }
    end

    context 'when ItaTaxonomy mappings are different from DB' do
      include_context 'with an adjusted ItaTaxonomy.mappings'
      it { is_expected.to eq([model]) }
    end

    context 'when ScreeningList::Sdn DB mappings have extra fields' do
      let(:model) { ScreeningList::Sdn }
      let(:type) { model.index_type }
      let(:index) { model.index_name }
      let(:field) { 'foo' }
      let(:mappings) { { type: 'keyword' } }

      before do
        new_mappings = model.mappings.deep_dup
        new_mappings[type][:properties][field] = mappings
        ES.client.indices.put_mapping(index: index, type: type, body: new_mappings)
      end
      after { model.recreate_index }

      it "does not consider ScreeningList::Sdn's index to need recreating" do
        # Field mappings found in the DB but not in the model are assumed to
        # be "dynamic mappings" added by ES in the absence of any given by us.
        db_mappings = ES.client.indices.get_field_mapping(index: index, field: field)
        expect(db_mappings[index]['mappings'].keys.count).to be > 0 # i.e. the mapping we added is present

        expect(subject).to be_empty
      end
    end

    context '.same?' do
      let(:a) { { foo: :bar } }
      let(:b) { nil }
      subject { described_class.same?(a, b) }
      it { is_expected.to eq(false) }
    end
  end
end
