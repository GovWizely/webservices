require 'spec_helper'

describe ScreeningList::PlcData do

  before { ScreeningList::Plc.recreate_index }
  let(:fixtures_file) { "#{Rails.root}/spec/fixtures/screening_lists/treasury_consolidated/consolidated.xml" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{File.dirname(__FILE__)}/plc/results.yaml") }

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
