require 'spec_helper'

describe ScreeningList::PlcData, vcr: { cassette_name: 'importers/screening_list/plc.yml' } do
  before { ScreeningList::Plc.recreate_index }
  let(:fixtures_file) { "#{Rails.root}/spec/fixtures/screening_lists/treasury_consolidated/consolidated.xml" }
  let(:resource) { fixtures_file }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{File.dirname(__FILE__)}/plc/results.yaml") }

  it_behaves_like 'an importer which can purge old documents'
  it_behaves_like 'a versionable resource'
  it_behaves_like 'an importer which indexes the correct documents'
end
