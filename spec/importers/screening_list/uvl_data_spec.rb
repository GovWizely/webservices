require 'spec_helper'

describe ScreeningList::UvlData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/screening_lists/uvl" }
  let(:fixtures_file) { "#{fixtures_dir}/uvl.csv" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/results.yaml") }

  describe '#import' do
    it 'loads unverified parties from specified resource' do
      ScreeningList::Uvl.should_receive(:index) do |uvl|
        uvl.should == expected
      end
      importer.import
    end
  end
end
