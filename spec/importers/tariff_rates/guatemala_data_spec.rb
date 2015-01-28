require 'spec_helper'

describe TariffRate::GuatemalaData do
  fixtures_dir = "#{Rails.root}/spec/fixtures/tariff_rates/guatemala"
  fixtures_file = "#{fixtures_dir}/guatemala.csv"
  fixtures_file_bad = "#{fixtures_dir}/guatemala_old.csv"

  s3_good = stubbed_s3_client('tariff_rate')
  s3_good.stub_responses(:get_object, body: open(fixtures_file))

  let(:importer) { described_class.new(fixtures_file, s3_good) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/results.yaml") }

  describe '#import' do
    it 'loads GUATEMALA tariff rates from specified resource' do
      expect(TariffRate::Guatemala).to receive(:index) do |res|
        expect(res).to eq(expected)
      end
      importer.import
    end
  end

end
