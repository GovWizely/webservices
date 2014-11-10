require 'spec_helper'

# http://www.state.gov/rss/channels/dl.xml
describe TradeEvent::DlData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/trade_events/dl/" }
  let(:resource) { "#{fixtures_dir}/trade_events.xml" }
  let(:importer) { described_class.new(resource) }

  it_behaves_like 'an importer which can purge old documents'

  describe '#import' do
    let(:expected) { YAML.load_file("#{fixtures_dir}trade_events.yaml") }

    it 'loads Direct Line trade events from specified resource' do
      expect(TradeEvent::Dl).to receive(:index) do |dl_trade_events|
        expect(dl_trade_events).to eq(expected)
      end
      importer.import
    end
  end
end
