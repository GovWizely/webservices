require 'spec_helper'

describe BisEntityData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/bis_entities" }
  let(:fixtures_file) { "#{fixtures_dir}/el.csv" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/results.yaml") }

  describe '#import' do
    it 'loads BIS entities from specified resource' do
      BisEntity.should_receive(:index) do |el|
        el.should == expected
      end
      importer.import
    end
  end
end
