require 'spec_helper'

describe TradeEvent::EximData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/trade_events/exim/" }
  let(:resource) { "#{fixtures_dir}/trade_events.xml" }
  let(:importer) do
    described_class.new(resource,
                        reject_if_ends_before: Date.parse('2013-01-11'))
  end

  it_behaves_like 'an importer which can purge old documents'

  describe '#import' do
    let(:expected) { YAML.load_file("#{fixtures_dir}/trade_events.yaml") }

    it 'loads EXIM trade events from specified resource' do
      TradeEvent::Exim.should_receive(:index) do |exim_trade_events|
        exim_trade_events.should == expected
      end
      importer.import
    end
  end
end
