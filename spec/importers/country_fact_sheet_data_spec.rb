require 'spec_helper'

describe CountryFactSheetData do
  let(:fixtures_dir) { "#{File.dirname(__FILE__)}/country_fact_sheet" }
  let(:fixtures_file) { "#{Rails.root}/spec/fixtures/country_fact_sheets/country_fact_sheets.json" }
  let(:resource) { fixtures_file }
  let(:importer) { CountryFactSheetData.new }
  let(:expected) { YAML.load_file("#{fixtures_dir}/country_fact_sheets.yaml") }

  before(:each) do
    allow(importer)
      .to receive(:open)
      .and_return(File.open(fixtures_file))
  end

  it_behaves_like 'an importer which can purge old documents'
  it_behaves_like 'an importer which indexes the correct documents'
end
