require 'spec_helper'

describe OfacSpecialDesignatedNationalData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/ofac_special_designated_nationals" }
  let(:fixtures_file) { "#{fixtures_dir}/sdn.xml" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/results.yaml") }

  describe '#import' do
    it 'loads special designated nationals from specified resource' do
      OfacSpecialDesignatedNational.should_receive(:index) do |sdn|
        sdn.should == expected
      end
      importer.import
    end
  end
end
