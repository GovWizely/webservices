require 'spec_helper'

describe ScreeningList::FseData do
  before { ScreeningList::Fse.recreate_index }
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/screening_lists" }
  let(:fixtures_file) { "#{fixtures_dir}/treasury_consolidated/consolidated.xml" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/fse/results.yaml") }

  it_behaves_like 'an importer which can purge old documents'

  describe '#import' do
    it 'loads foreign sanctions evaders from specified resource' do
      expect(ScreeningList::Fse).to receive(:index) do |fse|
        expect(fse).to eq(expected)
      end
      importer.import
    end
  end
end
