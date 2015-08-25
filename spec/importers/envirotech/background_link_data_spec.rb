require 'spec_helper'

describe Envirotech::BackgroundLinkData do
  let(:fixtures_file) { "#{Rails.root}/spec/fixtures/envirotech/background_link_articles/background_link_articles.json" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{File.dirname(__FILE__)}/background_link/background_link_articles.yaml") }

  it_behaves_like 'an importer which can purge old documents'
  it_behaves_like 'an importer which versions resources'
  it_behaves_like 'an importer which indexes the correct documents'
end
