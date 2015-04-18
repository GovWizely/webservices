require 'spec_helper'

describe ItaOfficeLocationData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/ita_office_locations" }
  let(:resources_dir) { "#{File.dirname(__FILE__)}/ita_office_location" }

  it_behaves_like 'an importer which cannot purge old documents'

  describe '#import' do
    context 'when importing domestic data' do
      let(:domestic_resource) { "#{fixtures_dir}/odo.xml" }
      let(:domestic_importer) { ItaOfficeLocationData.new(domestic_resource) }
      let(:odo_hash) { YAML.load_file("#{resources_dir}/odo.yaml") }

      it 'loads domestic office locations from specified resource' do
        expect(ItaOfficeLocation).to receive(:index) do |ita_office_locations|
          expect(ita_office_locations.size).to eq(116)
          116.times { |x| expect(ita_office_locations[x]).to eq(odo_hash[x]) }
        end
        domestic_importer.import
      end
    end

    context 'when importing foreign data' do
      let(:foreign_resource) { "#{fixtures_dir}/oio.xml" }
      let(:foreign_importer) { ItaOfficeLocationData.new(foreign_resource) }
      let(:oio_hash) { YAML.load_file("#{resources_dir}/oio.yaml") }

      it 'loads foreign office locations from specified resource' do
        expect(ItaOfficeLocation).to receive(:index) do |ita_office_locations|
          expect(ita_office_locations.size).to eq(113)
          113.times { |x| expect(ita_office_locations[x]).to eq(oio_hash[x]) }
        end
        foreign_importer.import
      end
    end
  end
end
