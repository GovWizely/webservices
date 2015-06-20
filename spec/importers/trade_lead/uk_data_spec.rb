require 'spec_helper'

describe TradeLead::UkData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/trade_leads/uk" }
  let(:fixtures_file) { "#{fixtures_dir}/uk_trade_leads.csv" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{File.dirname(__FILE__)}/uk/results.yaml") }

  it_behaves_like 'an importer which can purge old documents'
  it_behaves_like 'an importer which indexes the correct documents'
end
