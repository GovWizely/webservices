require 'spec_helper'

describe ScreeningList::DplData do
  before { ScreeningList::Dpl.recreate_index }
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/screening_lists/dpl" }
  let(:fixtures_file) { "#{fixtures_dir}/dpl.txt" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/results.yaml") }

  it_behaves_like 'an importer which can purge old documents'

  describe '#import' do
    it 'loads denied persons from specified resource' do
      expect(ScreeningList::Dpl).to receive(:index) do |dpl|
        expect(dpl).to eq(expected)
      end
      importer.import
    end
  end
end
