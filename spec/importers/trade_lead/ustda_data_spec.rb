require 'spec_helper'

describe TradeLead::UstdaData, vcr: { cassette_name: 'importers/trade_leads/ustda.yml', record: :once } do
  include_context 'ItaTaxonomy data'

  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/trade_leads/ustda" }
  let(:resource) { "#{fixtures_dir}/leads.xml" }
  let(:rss) { "#{fixtures_dir}/rss.xml" }
  let(:importer) { described_class.new(resource, rss) }
  let(:expected) { YAML.load_file("#{File.dirname(__FILE__)}/ustda/results.yaml") }
  before { allow(Date).to receive(:current).and_return(Date.parse('2015-12-18')) }

  it_behaves_like 'an importer which can purge old documents'
  it_behaves_like 'an importer which indexes the correct documents'
  it_behaves_like 'a versionable resource'
end
