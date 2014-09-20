require 'spec_helper'

describe TradeEvent::SbaData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/trade_events/sba" }
  let(:resource) { "#{fixtures_dir}/new_events_listing.xml?offset=0" }
  let(:importer) do
    described_class.new(resource,
                        reject_if_ends_before: Date.parse('2013-01-11'))
  end

  describe '#import' do
    let(:expected_batch_1) { YAML.load_file("#{fixtures_dir}/imported_batch_1.yaml") }
    let(:expected_batch_2) { YAML.load_file("#{fixtures_dir}/imported_batch_2.yaml") }

    it 'loads SBA trade events from specified resource' do
      TradeEvent::Sba.should_receive(:index) do |sba_trade_events|
        sba_trade_events.should == expected_batch_1
      end
      TradeEvent::Sba.should_receive(:index) do |sba_trade_events|
        sba_trade_events.should == expected_batch_2
      end
      importer.import
    end
  end
end