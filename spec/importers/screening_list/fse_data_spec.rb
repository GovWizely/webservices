require 'spec_helper'

describe ScreeningList::FseData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/screening_lists/fse" }
  let(:fixtures_file) { "#{fixtures_dir}/fse.xml" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/results.yaml") }

  describe '#import' do
    it 'loads foreign sanctions evaders from specified resource' do
      ScreeningList::Fse.should_receive(:index) do |fse|
        fse.should == expected
      end
      importer.import
    end
  end
end
