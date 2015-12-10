require 'spec_helper'

describe TradeLead::McaData, vcr: { cassette_name: 'importers/trade_leads/mca.yml', record: :once } do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/trade_leads/mca" }
  let(:fixtures_file) { "#{fixtures_dir}/mca_leads.xml" }
  let(:resource) { fixtures_file }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/results.yaml") }

  it_behaves_like 'an importer which indexes the correct documents'

  describe '#import' do
    it 'loads when date format is not correct' do
      allow(Date).to receive(:parse).and_raise(ArgumentError)
      expect(TradeLead::Mca).to receive(:index) do |trade_leads|
        expect(trade_leads.size).to eq(3)
      end
      importer.model_class.recreate_index
      importer.import
    end

    it 'loads when country is not correct' do
      allow(IsoCountryCodes).to receive(:find).and_raise(IsoCountryCodes::UnknownCodeError)

      expect(TradeLead::Mca).to receive(:index) do |trade_leads|
        expect(trade_leads.size).to eq(3)
      end
      importer.model_class.recreate_index
      importer.import
    end
  end
end
