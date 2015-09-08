require 'spec_helper'

describe TradeEvent::DlData do
  let(:resource) { "#{Rails.root}/spec/fixtures/trade_events/dl/trade_events.xml" }
  let(:importer) { described_class.new(resource) }
  let(:expected) { YAML.load_file("#{File.dirname(__FILE__)}/dl/results.yaml") }

  it_behaves_like 'an importer which can purge old documents'
  it_behaves_like 'a versionable resource'
  it_behaves_like 'an importer which indexes the correct documents'
end
