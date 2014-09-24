require 'spec_helper'

describe ScreeningList::ElData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/screening_lists/el" }
  let(:fixtures_file) { "#{fixtures_dir}/el.csv" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/results.yaml") }

  describe '#import' do
    it 'loads BIS entities from specified resource' do
      ScreeningList::El.should_receive(:index) do |el|
        el.should == expected
      end
      importer.import
    end
  end
end
