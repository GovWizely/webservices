require 'spec_helper'

describe ImportEmptyIndices do

  before(:all) { Webservices::Application.model_classes.each(&:recreate_index) }
  subject { described_class.call(dry_run: true) }

  describe '.call' do
    context 'with all indices empty' do
      it { is_expected.to eq(Webservices::Application.model_classes) }
    end

    context 'with one index populated' do
      include_context 'ScreeningList::Dpl data'
      after { ScreeningList::Dpl.recreate_index }
      it { is_expected.not_to include(ScreeningList::Dpl) }
    end
  end

end
