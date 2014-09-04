require 'spec_helper'

describe DdtcAecaDebarredPartyData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/ddtc_aeca_debarred_parties" }
  let(:fixtures_file) { "#{fixtures_dir}/aeca_debarred_parties.csv" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/results.yaml") }

  describe '#import' do
    it 'loads aeca debarred parties from specified resource' do
      DdtcAecaDebarredParty.should_receive(:index) do |adp|
        adp.should == expected
      end
      importer.import
    end
  end
end
