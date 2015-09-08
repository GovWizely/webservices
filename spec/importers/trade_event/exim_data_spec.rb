require 'spec_helper'

describe TradeEvent::EximData do
  let(:resource) { "#{Rails.root}/spec/fixtures/trade_events/exim/trade_events.xml" }
  let(:importer) do
    described_class.new(resource,
                        reject_if_ends_before: Date.parse('2013-01-11'))
  end
  let(:expected) { YAML.load_file("#{File.dirname(__FILE__)}/exim/results.yaml") }

  it_behaves_like 'an importer which can purge old documents'
  it_behaves_like 'a versionable resource'
  it_behaves_like 'an importer which indexes the correct documents'
end
