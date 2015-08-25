require 'spec_helper'

describe Envirotech::IssueData do
  include_context 'empty Envirotech indices'
  let(:fixtures_file) { "#{Rails.root}/spec/fixtures/envirotech/issue_articles/issue_articles.json" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{File.dirname(__FILE__)}/issue/issue_articles.yaml") }

  it_behaves_like 'an importer which can purge old documents'
  it_behaves_like 'an importer which versions resources'
  it_behaves_like 'an importer which indexes the correct documents'
end
