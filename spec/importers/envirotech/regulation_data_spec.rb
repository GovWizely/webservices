require 'spec_helper'

describe Envirotech::RegulationData do
  let(:fixtures_file) { "#{Rails.root}/spec/fixtures/envirotech/regulation_articles/regulation_articles.json" }
  let(:expected) { YAML.load_file("#{File.dirname(__FILE__)}/regulation/regulation_articles.yaml") }

  let(:relational_fixtures_file) { "#{Rails.root}/spec/fixtures/envirotech/relations_data/issue_solution_regulation.json" }
  let(:relational_data) { JSON.parse(open(relational_fixtures_file).read) }

  let(:importer) { described_class.new(fixtures_file, relation_data: relational_data) }

  it_behaves_like 'an importer which can purge old documents'
  it_behaves_like 'an importer which versions resources'
  it_behaves_like 'an importer which indexes the correct documents'
end
