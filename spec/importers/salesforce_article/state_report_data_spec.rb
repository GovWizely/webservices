require 'spec_helper'

describe SalesforceArticle::StateReportData do
  let(:fixtures_path) { "#{Rails.root}/spec/fixtures/salesforce_articles/state_report_sobjects.yml" }
  let(:client) { StubbedRestforce.new(restforce_collection(fixtures_path)) }
  let(:importer) { described_class.new(client) }
  let(:expected) { YAML.load_file("#{File.dirname(__FILE__)}/state_report/results.yaml") }

  it_behaves_like 'an importer which can purge old documents'
  it_behaves_like 'an importer which indexes the correct documents'
end
