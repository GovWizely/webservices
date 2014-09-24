require 'spec_helper'

describe ScreeningList::IsnData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/screening_lists/isn" }
  let(:fixtures_file) { "#{fixtures_dir}/isn.csv" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/results.yaml") }

  describe '#import' do
    it 'loads ISN entries from specified resource' do
      ScreeningList::Isn.should_receive(:index) do |isn|
        isn.should == expected
      end
      importer.import
    end
  end
end
