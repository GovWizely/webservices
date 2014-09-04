require 'spec_helper'

describe BisUnverifiedPartyData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/bis_unverified_parties" }
  let(:fixtures_file) { "#{fixtures_dir}/uvl.csv" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/results.yaml") }

  describe '#import' do
    it 'loads unverified parties from specified resource' do
      BisUnverifiedParty.should_receive(:index) do |uvl|
        uvl.should == expected
      end
      importer.import
    end
  end
end
