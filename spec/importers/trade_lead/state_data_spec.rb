require 'spec_helper'

describe TradeLead::StateData, vcr: { cassette_name: 'importers/trade_leads/state.yml', record: :once } do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/trade_leads/state" }
  let(:fixtures_file) { "#{fixtures_dir}/state_trade_leads.json" }
  let(:resource) { fixtures_file }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{File.dirname(__FILE__)}/state/results.yaml") }

  it_behaves_like 'an importer which can purge old documents'
  it_behaves_like 'an importer which indexes the correct documents'
  it_behaves_like 'a versionable resource'
end
