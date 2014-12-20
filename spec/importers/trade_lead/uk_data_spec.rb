require 'spec_helper'

describe TradeLead::UkData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/trade_leads/uk" }
  let(:fixtures_file) { "#{fixtures_dir}/uk_trade_leads.csv" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/results.yaml") }

  it_behaves_like 'an importer which can purge old documents'

  describe '#import' do
    it 'loads UK trade leads from specified resource' do
      expect(TradeLead::Uk).to receive(:index) do |trade_leads|
        expect(trade_leads.size).to eq(3)
        expect(trade_leads[0]).to eq(expected[0])
        expect(trade_leads[1]).to eq(expected[1])
        expect(trade_leads[2]).to eq(expected[2])
      end
      importer.import
    end
  end
end
