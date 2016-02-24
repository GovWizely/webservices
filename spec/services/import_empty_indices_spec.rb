require 'spec_helper'

describe ImportEmptyIndices do
  before(:all) { Webservices::Application.model_classes.each(&:recreate_index) }
  subject { described_class.call(dry_run: true) }

  describe '.call' do
    let(:expected) do
      Webservices::Application
        .model_classes
        .find_all { |m| !m.importer_class.disabled? }
    end
    context 'with all indices empty' do
      it { is_expected.to eq(expected) }
    end

    context 'with one index populated' do
      include_context 'ScreeningList::Dpl data'
      after { ScreeningList::Dpl.recreate_index }
      it { is_expected.not_to include(ScreeningList::Dpl) }
    end

    context 'considering disabled importers' do
      let(:importer_classes) { Webservices::Application.model_classes.map(&:importer_class) }
      let(:disabled) { importer_classes.find_all(&:disabled?) }
      it "doesn't include disabled importers" do
        expect(disabled.count).to be >= 0
        expect(subject.find_all { |c| c.importer_class.disabled? }.count).to eq 0
      end
    end
  end
end
