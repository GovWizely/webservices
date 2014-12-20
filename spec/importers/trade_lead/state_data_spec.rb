require 'spec_helper'

describe TradeLead::StateData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/trade_leads/state" }
  let(:fixtures_file) { "#{fixtures_dir}/state_trade_leads.json" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/results.yaml") }

  it_behaves_like 'an importer which can purge old documents'

  describe '#import' do
    it 'loads state trade leads from specified resource' do
      expect(TradeLead::State).to receive(:index) do |trade_leads|
        expect(trade_leads.size).to eq(4)
        expect(trade_leads[0]).to eq(expected[0])
        expect(trade_leads[1]).to eq(expected[1])
        expect(trade_leads[2]).to eq(expected[2])
        expect(trade_leads[3]).to eq(expected[3])
      end
      importer.import
    end
  end
end
