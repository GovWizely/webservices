require 'spec_helper'

describe TradeEvent::SbaData do
  include_context 'ItaTaxonomy data'

  before(:all) do
    TradeEvent::Sba.recreate_index
  end

  let(:resource) { "#{Rails.root}/spec/fixtures/trade_events/sba/new_events_listing.xml?offset=0" }
  let(:importer) do
    described_class.new(resource,
                        { reject_if_ends_before: Date.parse('2013-01-11') },
                        'r',)
  end

  it_behaves_like 'an importer which can purge old documents'

  describe '#import' do
    let(:results_dir) { "#{File.dirname(__FILE__)}/sba" }
    let(:expected_batch_1) { YAML.load_file("#{results_dir}/results_batch_1.yaml") }
    let(:expected_batch_2) { YAML.load_file("#{results_dir}/results_batch_2.yaml") }

    it 'loads SBA trade events from specified resource' do
      expect(TradeEvent::Sba).to receive(:index) do |sba_trade_events|
        expect(sba_trade_events).to eq(expected_batch_1)
      end
      expect(TradeEvent::Sba).to receive(:index) do |sba_trade_events|
        expect(sba_trade_events).to eq(expected_batch_2)
      end
      importer.import
    end
  end

  describe '#available_version' do
    it 'is as expected' do
      expect(importer.available_version)
        .to eq('bd0efd6f71aa718956eb55dcd030a3814199129744badf8464e73ccdde74b385e798c18522d3ba9d')
    end
  end
end
