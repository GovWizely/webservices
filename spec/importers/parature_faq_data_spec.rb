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
        28.times { |x| entries[x].should == entry_hash[x]}

      end
      importer.import
    end
  end
end