require 'spec_helper'

describe TradeLead::StateData, vcr: { cassette_name: 'importers/trade_leads/state.yml', record: :once } do
  include_context 'ItaTaxonomy data'

  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/trade_leads/state" }
  let(:fixtures_file) { "#{fixtures_dir}/state_trade_leads.json" }
  let(:resource) { fixtures_file }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{File.dirname(__FILE__)}/state/results.yaml") }
  before { allow(Date).to receive(:current).and_return(Date.parse('2013-06-11')) }

  it_behaves_like 'an importer which can purge old documents'
  it_behaves_like 'an importer which indexes the correct documents'
  it_behaves_like 'a versionable resource'
end
