require 'spec_helper'

describe ScreeningList::IsnData, vcr: { cassette_name: 'importers/screening_list/isn.yml' } do
  before { ScreeningList::Isn.recreate_index }
  let(:fixtures_file) { "#{Rails.root}/spec/fixtures/screening_lists/isn/isn.csv" }
  let(:resource) { fixtures_file }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{File.dirname(__FILE__)}/isn/results.yaml") }

  it_behaves_like 'an importer which can purge old documents'
  it_behaves_like 'a versionable resource'
  it_behaves_like 'an importer which indexes the correct documents'
end
