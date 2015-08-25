require 'spec_helper'

describe Envirotech::ProviderSolutionData do
  include_context 'empty Envirotech indices'
  let(:fixtures_file) { "#{Rails.root}/spec/fixtures/envirotech/provider_solution_articles/provider_solution_articles.json" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{File.dirname(__FILE__)}/provider_solution/provider_solution_articles.yaml") }

  it_behaves_like 'an importer which can purge old documents'
  it_behaves_like 'an importer which versions resources'
  it_behaves_like 'an importer which indexes the correct documents'
end
