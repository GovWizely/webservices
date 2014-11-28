require 'spec_helper'

describe TradeLead::AustraliaData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/trade_leads/australia" }
  let(:fixtures_file) { "#{fixtures_dir}/trade_leads.csv" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:trade_leads_hash) { YAML.load_file("#{fixtures_dir}/trade_leads.yaml") }

  it_behaves_like 'an importer which cannot purge old documents'

  describe '#import' do
    it 'loads trade leads from specified resource' do
      expect(TradeLead::Australia).to receive(:index) do |trade_leads|
        expect(trade_leads.size).to eq(3)
        expect(trade_leads[0]).to eq(trade_leads_hash[0])
        expect(trade_leads[1]).to eq(trade_leads_hash[1])
        expect(trade_leads[2]).to eq(trade_leads_hash[2])
      end
      importer.import
    end
  end
end
