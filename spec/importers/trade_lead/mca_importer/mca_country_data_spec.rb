require 'spec_helper'

describe TradeLead::McaImporter::McaCountryData do
  let(:mca_class) { Class.new { include TradeLead::McaImporter::McaCountryData } }
  let(:mca_country_string) { 'country/us - United States' }
  describe 'extract_iso2_code(mca_country_string)' do
    subject { mca_class.new.extract_iso2_code(mca_country_string) }
    it { is_expected.to eq('US') }
  end
  describe 'extract_country_name(mca_country_string)' do
    subject { mca_class.new.extract_country_name(mca_country_string) }
    it { is_expected.to eq('United States') }
  end
end
