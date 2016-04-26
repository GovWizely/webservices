require 'spec_helper'

describe TradeEvent::ItaData, vcr: { cassette_name: 'importers/trade_events/ita.yml', record: :once } do
  include_context 'ItaTaxonomy data'

  let(:resource) { "#{Rails.root}/spec/fixtures/trade_events/ita/trade_events.xml" }
  let(:importer) { described_class.new(resource) }
  let(:expected) { YAML.load_file("#{File.dirname(__FILE__)}/ita/results.yaml") }
  before { allow(Date).to receive(:current).and_return(Date.parse('2013-10-07')) }

  it_behaves_like 'an importer which can purge old documents'
  it_behaves_like 'a versionable resource'
  it_behaves_like 'an importer which indexes the correct documents'
end
