require 'spec_helper'

describe DataSources::DataExtractor do
  before(:all) do
    VCR.insert_cassette('importers/data_sources/csv.yml', record: :once)
  end

  context 'resource is a URL for a text file' do
    let(:resource) { 'https://gist.githubusercontent.com/loren/14efb4652cff15fa105d/raw/5238538827963e6b6caffad6b6fbd280a3740b21/commas.csv' }
    let(:data_source) { DataSources::DataExtractor.new(resource) }

    subject { data_source.data }

    it { is_expected.to eq("f1,f2\nval1 from commas,1\nval2 from commas,2") }
  end

  after(:all) do
    VCR.eject_cassette('importers/data_sources/csv.yml')
  end
end
