require 'spec_helper'

describe TradeEvent::EximData do
  let(:resource) { "#{Rails.root}/spec/fixtures/trade_events/exim/trade_events.xml" }
  let(:importer) do
    described_class.new(resource,
                        reject_if_ends_before: Date.parse('2013-01-11'))
  end

  it_behaves_like 'an importer which can purge old documents'

  describe '#import' do
    let(:expected) { YAML.load_file("#{File.dirname(__FILE__)}/exim/results.yaml") }

    it 'loads EXIM trade events from specified resource' do
      expect(TradeEvent::Exim).to receive(:index) do |exim_trade_events|
        expect(exim_trade_events).to eq(expected)
      end
      importer.import
    end
  end
end
