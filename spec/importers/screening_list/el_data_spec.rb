require 'spec_helper'

describe ScreeningList::ElData do
  before { ScreeningList::El.recreate_index }
  let(:fixtures_file) { "#{Rails.root}/spec/fixtures/screening_lists/el/el.csv" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{File.dirname(__FILE__)}/el/results.yaml") }

  it_behaves_like 'an importer which can purge old documents'
  it_behaves_like 'an importer which versions resources'
  it_behaves_like 'an importer which indexes the correct documents'
end
