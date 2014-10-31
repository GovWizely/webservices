require 'spec_helper'

describe ScreeningList::PlcData do
  before { ScreeningList::Plc.recreate_index }
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/screening_lists/plc" }
  let(:fixtures_file) { "#{fixtures_dir}/ns_plc.xml" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/results.yaml") }

  it_behaves_like 'an importer which can purge old documents'

  describe '#import' do
    it 'loads PLC from specified resource' do
      expect(ScreeningList::Plc).to receive(:index) do |plc|
        expect(plc).to eq(expected)
      end
      importer.import
    end
  end
end
