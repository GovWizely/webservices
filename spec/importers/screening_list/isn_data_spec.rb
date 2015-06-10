require 'spec_helper'

describe ScreeningList::IsnData do
  before { ScreeningList::Isn.recreate_index }
  let(:fixtures_file) { "#{Rails.root}/spec/fixtures/screening_lists/isn/isn.csv" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{File.dirname(__FILE__)}/isn/results.yaml") }

  it_behaves_like 'an importer which can purge old documents'
  it_behaves_like 'an importer which versions resources'
  it_behaves_like 'an importer which indexes the correct documents'
end
