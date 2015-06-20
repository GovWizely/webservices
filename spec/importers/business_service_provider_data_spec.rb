require 'spec_helper'

describe BusinessServiceProviderData do
  let(:fixtures_file) { "#{Rails.root}/spec/fixtures/business_service_providers/articles.json" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{File.dirname(__FILE__)}/business_service_provider/articles.yaml") }

  it_behaves_like 'an importer which can purge old documents'
  it_behaves_like 'an importer which versions resources'
  it_behaves_like 'an importer which indexes the correct documents'
end
