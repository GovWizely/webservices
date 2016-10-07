require 'spec_helper'

describe Envirotech::ProviderSolutionData do
  include_context 'empty Envirotech indices'
  include_context 'Envirotech::Provider data'
  include_context 'Envirotech::Solution data'

  let(:fixtures_file) { "#{Rails.root}/spec/fixtures/envirotech/provider_solutions.json" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{File.dirname(__FILE__)}/provider_solution/provider_solution_articles.yaml") }
  let(:resource) { fixtures_file }

  it_behaves_like 'an importer which can purge old documents'
  it_behaves_like 'a versionable resource'
  it_behaves_like 'an importer which indexes the correct documents'
end
