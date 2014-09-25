require 'spec_helper'

describe ScreeningList::SsiData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/screening_lists/ssi" }
  let(:fixtures_file) { "#{fixtures_dir}/ssi.xml" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/results.yaml") }

  describe '#import' do
    it 'loads SSI from specified resource' do
      ScreeningList::Ssi.should_receive(:index) do |ssi|
        ssi.should == expected
      end
      importer.import
    end
  end
end
