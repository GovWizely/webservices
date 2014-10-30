require 'spec_helper'

describe TariffRate::KoreaData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/tariff_rates/korea" }
  let(:fixtures_file) { "#{fixtures_dir}/korea.csv" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/results.yaml") }

  describe '#import' do
    it 'loads KOREA tariff rates from specified resource' do
      TariffRate::Korea.should_receive(:index) do |res|
        res.should == expected
      end
      importer.import
    end
  end
end
