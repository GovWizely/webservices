require 'spec_helper'

describe TariffRate::ElSalvadorData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/tariff_rates/el_salvador" }
  let(:fixtures_file) { "#{fixtures_dir}/el_salvador.csv" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/results.yaml") }

  describe '#import' do
    it 'loads EL_SALVADOR tariff rates from specified resource' do
      TariffRate::ElSalvador.should_receive(:index) do |res|
        res.should == expected
      end
      importer.import
    end
  end
end