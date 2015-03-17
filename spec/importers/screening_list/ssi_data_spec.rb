require 'spec_helper'

describe ScreeningList::SsiData do
  before { ScreeningList::Ssi.recreate_index }
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/screening_lists" }
  let(:fixtures_file) { "#{fixtures_dir}/treasury_consolidated/consolidated.xml" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/ssi/results.yaml") }

  it_behaves_like 'an importer which can purge old documents'

  describe '#import' do
    it 'loads SSI from specified resource' do
      expect(ScreeningList::Ssi).to receive(:index) do |ssi|
        expect(ssi).to eq(expected)
      end
      importer.import
    end
  end
end
