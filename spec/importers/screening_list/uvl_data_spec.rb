require 'spec_helper'

describe ScreeningList::UvlData do
  before { ScreeningList::Uvl.recreate_index }
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/screening_lists/uvl" }
  let(:fixtures_file) { "#{fixtures_dir}/uvl.csv" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/results.yaml") }

  it_behaves_like 'an importer which can purge old documents'

  describe '#import' do
    it 'loads unverified parties from specified resource' do
      expect(ScreeningList::Uvl).to receive(:index) do |uvl|
        expect(uvl).to eq(expected)
      end
      importer.import
    end
  end
end
