require 'spec_helper'

describe ScreeningList::DtcData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/screening_lists/dtc" }
  let(:fixtures_file) { "#{fixtures_dir}/itar_debarred_parties.csv" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/results.yaml") }

  describe '#import' do
    it 'loads itar debarred parties from specified resource' do
      ScreeningList::Dtc.should_receive(:index) do |dtc|
        dtc.should == expected
      end
      importer.import
    end
  end
end
