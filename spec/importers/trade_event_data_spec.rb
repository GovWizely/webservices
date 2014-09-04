require 'spec_helper'

describe TradeEventData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/trade_events" }
  let(:resource) { "#{fixtures_dir}/trade_events.xml" }
  let(:importer) { TradeEventData.new(resource) }

  describe '#import' do
    let(:trade_event_hash) { YAML.load_file("#{fixtures_dir}/trade_events.yaml") }

    before { Date.stub(:current).and_return(Date.parse('2013-10-07')) }

    it 'loads trade events from specified resource' do
      TradeEvent.should_receive(:index) do |trade_events|
        trade_events.size.should == 5
        trade_events[0].should == trade_event_hash[0]
        trade_events[1].should == trade_event_hash[1]
        trade_events[2].should == trade_event_hash[2]
        trade_events[3].should == trade_event_hash[3]
        trade_events[4].should == trade_event_hash[4]
      end
      importer.import
    end
  end
end
