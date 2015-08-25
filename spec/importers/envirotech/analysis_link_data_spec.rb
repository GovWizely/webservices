require 'spec_helper'

describe Envirotech::AnalysisLinkData do
  let(:fixtures_file) { "#{Rails.root}/spec/fixtures/envirotech/analysis_link_articles/analysis_link_articles.json" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{File.dirname(__FILE__)}/analysis_link/analysis_link_articles.yaml") }

  it_behaves_like 'an importer which can purge old documents'
  it_behaves_like 'an importer which versions resources'
  it_behaves_like 'an importer which indexes the correct documents'
end
