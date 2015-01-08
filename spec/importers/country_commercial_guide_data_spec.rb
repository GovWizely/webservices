require 'spec_helper'

describe CountryCommercialGuideData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/country_commercial_guides" }
  let(:resource) { "#{fixtures_dir}/yaml/*" }
  let(:importer) { CountryCommercialGuideData.new(resource) }

  describe '#import' do
    let(:entry_hash) { YAML.load_file("#{fixtures_dir}/results.yaml") }

    it 'loads country commercial guides from specified resource' do
      expect(CountryCommercialGuide).to receive(:index) do |entries|

        expect(entries.size).to eq(6)
        expect(entries).to match_array entry_hash

      end
      importer.import
    end
  end
end
