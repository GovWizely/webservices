require 'spec_helper'

describe TradeEvent::ItaData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/trade_events/ita/" }
  let(:resource) { "#{fixtures_dir}/trade_events.xml" }
  let(:importer) { described_class.new(resource) }

  it_behaves_like 'an importer which can purge old documents'

  describe '#import' do
    let(:expected) { YAML.load_file("#{fixtures_dir}/trade_events.yaml") }

    before { allow(Date).to receive(:current).and_return(Date.parse('2013-10-07')) }

    it 'loads ITA trade events from specified resource' do
      expect(TradeEvent::Ita).to receive(:index) do |ita_trade_events|
        expect(ita_trade_events).to eq(expected)
      end
      importer.import
    end
  end
end
