require 'spec_helper'

describe ScreeningList::Consolidated, type: :model do
  describe '.index_names' do
    subject { described_class.index_names(sources) }

    let(:all_index_names) do
      %w(dpl dtc el eo13599 fse isn part561 plc sdn ssi uvl)
        .map { |x| "test:webservices:screening_list:#{x}s" }
    end

    context 'with one source' do
      context 'which is included in the list of models' do
        let(:sources) { ['SDN'] }
        it { is_expected.to eq ['test:webservices:screening_list:sdns'] }
      end

      context 'which is not included in the list of models' do
        let(:sources) { ['Foo'] }
        it { is_expected.to eq all_index_names }
      end
    end

    context 'with multiple sources' do
      context 'all of which are included in the list of models' do
        let(:sources) { %w(SDN FSE DTC) }
        it do
          is_expected.to eq ['test:webservices:screening_list:dtcs',
                             'test:webservices:screening_list:fses',
                             'test:webservices:screening_list:sdns',]
        end
      end

      context 'some of which are included in the list of models' do
        let(:sources) { %w(Foo Bar DTC) }
        it { is_expected.to eq ['test:webservices:screening_list:dtcs'] }
      end

      context 'some of which are included in the list of models' do
        let(:sources) { %w(Foo Bar) }
        it { is_expected.to eq all_index_names }
      end
    end
  end
end
