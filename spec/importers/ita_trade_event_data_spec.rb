require 'spec_helper'

describe ItaTradeEventData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/ita_trade_events" }
  let(:resource) { "#{fixtures_dir}/trade_events.xml" }
  let(:importer) { described_class.new(resource) }

  describe '#import' do
    let(:expected) { YAML.load_file("#{fixtures_dir}/trade_events.yaml") }

    before { Date.stub(:current).and_return(Date.parse('2013-10-07')) }

    it 'loads ITA trade events from specified resource' do
      ItaTradeEvent.should_receive(:index) do |ita_trade_events|
        ita_trade_events.should == expected
      end
      importer.import
    end
  end
end
