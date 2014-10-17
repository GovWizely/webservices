require 'spec_helper'

describe ScreeningList::DplData do
  before { ScreeningList::Dpl.recreate_index }
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/screening_lists/dpl" }
  let(:fixtures_file) { "#{fixtures_dir}/dpl.txt" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/results.yaml") }

  describe '#import' do
    it 'loads denied persons from specified resource' do
      ScreeningList::Dpl.should_receive(:index) do |dpl|
        dpl.should == expected
      end
      importer.import
    end
  end
end
