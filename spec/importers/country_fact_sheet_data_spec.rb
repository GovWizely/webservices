require 'spec_helper'

describe CountryFactSheetData do
  let(:fixtures_dir) { "#{File.dirname(__FILE__)}/country_fact_sheet" }
  let(:fixtures_file) { "#{Rails.root}/spec/fixtures/country_fact_sheets/country_fact_sheets.json" }
  let(:resource) { fixtures_file }
  let(:importer) { CountryFactSheetData.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/country_fact_sheets.yaml") }

  it_behaves_like 'an importer which cannot purge old documents'
  it_behaves_like 'an importer which indexes the correct documents'
  it_behaves_like 'a versionable resource'
end
