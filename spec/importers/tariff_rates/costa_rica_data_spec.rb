require 'spec_helper'

describe TariffRate::CostaRicaData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/tariff_rates/costa_rica" }
  let(:fixtures_file) { "#{fixtures_dir}/costa_rica.csv" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/results.yaml") }

  describe '#import' do
    it 'loads COSTA_RICA tariff rates from specified resource' do
      TariffRate::CostaRica.should_receive(:index) do |res|
        res.should == expected
      end
      importer.import
    end
  end
end
