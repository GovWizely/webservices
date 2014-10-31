require 'spec_helper'

describe TradeEventData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/trade_events" }
  let(:resource) { "#{fixtures_dir}/trade_events.xml" }
  let(:importer) { TradeEventData.new(resource) }

  it_behaves_like 'an importer which cannot purge old documents'

  describe '#import' do
    let(:trade_event_hash) { YAML.load_file("#{fixtures_dir}/trade_events.yaml") }

    before { allow(Date).to receive(:current).and_return(Date.parse('2013-10-07')) }

    it 'loads trade events from specified resource' do
      expect(TradeEvent).to receive(:index) do |trade_events|
        expect(trade_events.size).to eq(5)
        expect(trade_events[0]).to eq(trade_event_hash[0])
        expect(trade_events[1]).to eq(trade_event_hash[1])
        expect(trade_events[2]).to eq(trade_event_hash[2])
        expect(trade_events[3]).to eq(trade_event_hash[3])
        expect(trade_events[4]).to eq(trade_event_hash[4])
      end
      importer.import
    end
  end
end
