require 'spec_helper'

describe ParatureFaqData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/parature_faqs" }
  let(:resource) { "#{fixtures_dir}/parature_faqs.json" }
  let(:importer) { ParatureFaqData.new(resource) }

  describe '#import' do
    let(:entry_hash) { JSON.parse open("#{fixtures_dir}/importer_output.json").read, symbolize_names: true }

    it 'loads parature faqs from specified resource' do
      ParatureFaq.should_receive(:index) do |entries|
        entries.size.should == 28

        entries[0].should == entry_hash[0]
        entries[1].should == entry_hash[1]
        entries[2].should == entry_hash[2]
        entries[3].should == entry_hash[3]
        entries[4].should == entry_hash[4]
        entries[5].should == entry_hash[5]
      end
      importer.import
    end
  end
end