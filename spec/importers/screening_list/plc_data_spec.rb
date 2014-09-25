require 'spec_helper'

describe ScreeningList::PlcData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/screening_lists/plc" }
  let(:fixtures_file) { "#{fixtures_dir}/ns_plc.xml" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/results.yaml") }

  describe '#import' do
    it 'loads PLC from specified resource' do
      ScreeningList::Plc.should_receive(:index) do |plc|
        plc.should == expected
      end
      importer.import
    end
  end
end
