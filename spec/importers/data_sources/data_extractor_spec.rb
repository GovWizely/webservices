require 'spec_helper'

describe DataSources::DataExtractor do
  context 'resource is a URL for a text file' do
    let(:resource) { 'https://gist.githubusercontent.com/loren/14efb4652cff15fa105d/raw/5238538827963e6b6caffad6b6fbd280a3740b21/commas.csv' }
    let(:data_source) { VCR.use_cassette('importers/data_sources/csv.yml') { DataSources::DataExtractor.new(resource) } }

    subject { data_source.data }

    it { is_expected.to eq("f1,f2\nval1 from commas,1\nval2 from commas,2") }
  end

  context 'resource encoding is not accurate' do
    let(:resource) { 'http://emenuapps.ita.doc.gov/ePublic/bsp/alljson/en/bsp.xml' }
    let(:data_source) { VCR.use_cassette('importers/data_sources/bsp.yml', record: :once) { DataSources::DataExtractor.new(resource) } }

    subject { data_source.data }

    it { is_expected.to match(/José Antonio Muñoz/) }
  end
end
