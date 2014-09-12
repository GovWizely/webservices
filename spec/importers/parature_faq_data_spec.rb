require 'spec_helper'

describe ParatureFaqData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/parature_faqs" }
  let(:resource) { "#{fixtures_dir}/articles/article%d.xml" }
  let(:importer) { ParatureFaqData.new(resource) }

  describe '#import' do
    let(:entry_hash) { YAML.load_file("#{fixtures_dir}/importer_output.yaml") }

    it 'loads parature faqs from specified resource' do
      ParatureFaq.should_receive(:index) do |entries|

        entries.size.should == 29
        entries.should match_array entry_hash

      end
      importer.import
    end
  end
end
