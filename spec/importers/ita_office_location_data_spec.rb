require 'spec_helper'

describe ItaOfficeLocationData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/ita_office_locations" }
  let(:resources_dir) { "#{File.dirname(__FILE__)}/ita_office_location" }
  let(:resource) { [resources_dir + '/odo.yaml', resources_dir + '/oio.yaml'] }
  let(:importer) { described_class.new(resource) }

  it_behaves_like 'a versionable resource'
  it_behaves_like 'an importer which cannot purge old documents'

  describe '#import' do
    context 'when importing domestic data' do
      let(:resource) { "#{fixtures_dir}/odo.xml" }
      let(:importer) { ItaOfficeLocationData.new(resource) }
      let(:expected) { YAML.load_file("#{resources_dir}/odo.yaml") }

      it_behaves_like 'an importer which indexes the correct documents'
    end

    context 'when importing foreign data' do
      let(:resource) { "#{fixtures_dir}/oio.xml" }
      let(:importer) { ItaOfficeLocationData.new(resource) }
      let(:expected) { YAML.load_file("#{resources_dir}/oio.yaml") }

      it_behaves_like 'an importer which indexes the correct documents'
    end
  end
end
