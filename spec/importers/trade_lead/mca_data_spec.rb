require 'spec_helper'

describe TradeLead::McaData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/trade_leads/mca" }
  let(:fixtures_file) { "#{fixtures_dir}/mca_leads.xml" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/results.yaml") }

  describe '#import' do
    it 'loads MCA trade leads from specified resource' do
      expect(TradeLead::Mca).to receive(:index) do |trade_leads|
        expect(trade_leads.size).to eq(3)
        expect(trade_leads[0]).to eq(expected[0])
        expect(trade_leads[1]).to eq(expected[1])
        expect(trade_leads[2]).to eq(expected[2])
      end
      importer.import
    end

    it 'loads when date format is not correct' do
      Date.stub(:parse).and_raise(ArgumentError)
      expect(TradeLead::Mca).to receive(:index) do |trade_leads|
        expect(trade_leads.size).to eq(3)
      end
      importer.import
    end

    it 'loads when country is not correct' do
      IsoCountryCodes.stub(:find).and_raise(IsoCountryCodes::UnknownCodeError)

      expect(TradeLead::Mca).to receive(:index) do |trade_leads|
        expect(trade_leads.size).to eq(3)
      end
      importer.import
    end
  end
end
