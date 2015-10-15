require 'spec_helper'

describe ScreeningList::DtcData, vcr: { cassette_name: 'importers/screening_list/dtc.yml' } do
  before { ScreeningList::Dtc.recreate_index }
  let(:fixtures_file) { "#{Rails.root}/spec/fixtures/screening_lists/dtc/itar_debarred_parties.csv" }
  let(:resource) { fixtures_file }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{File.dirname(__FILE__)}/dtc/results.yaml") }

  it_behaves_like 'an importer which can purge old documents'
  it_behaves_like 'a versionable resource'
  it_behaves_like 'an importer which indexes the correct documents'
end
