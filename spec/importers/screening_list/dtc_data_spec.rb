require 'spec_helper'

describe ScreeningList::DtcData do
  before { ScreeningList::Dtc.recreate_index }
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/screening_lists/dtc" }
  let(:fixtures_file) { "#{fixtures_dir}/itar_debarred_parties.csv" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/results.yaml") }

  it_behaves_like 'an importer which can purge old documents'

  describe '#import' do
    it 'loads itar debarred parties from specified resource' do
      expect(ScreeningList::Dtc).to receive(:index) do |dtc|
        expect(dtc).to eq(expected)
      end
      importer.import
    end
  end
end
