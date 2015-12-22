require 'spec_helper'

describe TradeLead::AustraliaData, vcr: { cassette_name: 'importers/trade_leads/australia.yml', record: :once } do
  let(:fixtures_dir) { '' }
  let(:fixtures_file) { "#{Rails.root}/spec/fixtures/trade_leads/australia/trade_leads.csv" }
  let(:resource) { fixtures_file }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{File.dirname(__FILE__)}/australia/results.yaml") }

  it_behaves_like 'an importer which can purge old documents'
  it_behaves_like 'an importer which indexes the correct documents'
  it_behaves_like 'a versionable resource'
end
