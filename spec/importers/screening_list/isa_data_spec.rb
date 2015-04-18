require 'spec_helper'

describe ScreeningList::IsaData do

  before { ScreeningList::Isa.recreate_index }
  let(:fixtures_file) { "#{Rails.root}/spec/fixtures/screening_lists/treasury_consolidated/consolidated.xml" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{File.dirname(__FILE__)}/isa/results.yaml") }

  it_behaves_like 'an importer which can purge old documents'

  describe '#import' do
    it 'loads ISA from specified resource' do
      expect(ScreeningList::Isa).to receive(:index) do |isa|
        expect(isa).to eq(expected)
      end
      importer.import
    end
  end
end
