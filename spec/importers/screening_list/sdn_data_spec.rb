require 'spec_helper'

describe ScreeningList::SdnData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/screening_lists/sdn" }
  let(:fixtures_file) { "#{fixtures_dir}/sdn.xml" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/results.yaml") }

  describe '#import' do
    it 'loads special designated nationals from specified resource' do
      ScreeningList::Sdn.should_receive(:index) do |sdn|
        sdn.should == expected
      end
      importer.import
    end
  end
end
