require 'spec_helper'

describe ItaOfficeLocationData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/ita_office_locations" }

  describe '#import' do
    context 'when importing domestic data' do
      let(:domestic_resource) { "#{fixtures_dir}/odo.xml" }
      let(:domestic_importer) { ItaOfficeLocationData.new(domestic_resource) }
      let(:odo_hash) { YAML.load_file("#{fixtures_dir}/odo.yaml") }

      it 'loads domestic office locations from specified resource' do
        ItaOfficeLocation.should_receive(:index) do |ita_office_locations|
          ita_office_locations.size.should == 116
          116.times { |x| ita_office_locations[x].should == odo_hash[x] }
        end
        domestic_importer.import
      end
    end

    context 'when importing foreign data' do
      let(:foreign_resource) { "#{fixtures_dir}/oio.xml" }
      let(:foreign_importer) { ItaOfficeLocationData.new(foreign_resource) }
      let(:oio_hash) { YAML.load_file("#{fixtures_dir}/oio.yaml") }

      it 'loads foreign office locations from specified resource' do
        ItaOfficeLocation.should_receive(:index) do |ita_office_locations|
          ita_office_locations.size.should == 113
          113.times { |x| ita_office_locations[x].should == oio_hash[x] }
        end
        foreign_importer.import
      end
    end
  end
end
