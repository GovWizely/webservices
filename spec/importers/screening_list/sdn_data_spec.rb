require 'spec_helper'

describe ScreeningList::SdnData do

  before { ScreeningList::Sdn.recreate_index }
  let(:fixtures_file) { "#{Rails.root}/spec/fixtures/screening_lists/sdn/sdn.xml" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{File.dirname(__FILE__)}/sdn/results.yaml") }

  it_behaves_like 'an importer which can purge old documents'

  describe '#import' do
    it 'loads special designated nationals from specified resource' do
      expect(ScreeningList::Sdn).to receive(:index) do |sdn|
        expect(sdn).to eq(expected)
      end
      importer.import
    end
  end
end
