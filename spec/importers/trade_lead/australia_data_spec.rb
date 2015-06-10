require 'spec_helper'

describe TradeLead::AustraliaData do
  let(:fixtures_dir) { '' }
  let(:fixtures_file) { "#{Rails.root}/spec/fixtures/trade_leads/australia/trade_leads.csv" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{File.dirname(__FILE__)}/australia/results.yaml") }

  it_behaves_like 'an importer which can purge old documents'
  it_behaves_like 'an importer which versions resources'
  it_behaves_like 'an importer which indexes the correct documents'
end
