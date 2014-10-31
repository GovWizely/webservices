require 'spec_helper'

describe ParatureFaqData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/parature_faqs" }
  let(:resource) { "#{fixtures_dir}/articles/article%d.xml" }
  let(:importer) { ParatureFaqData.new(resource) }

  it_behaves_like 'an importer which can purge old documents'

  describe '#import' do
    let(:entry_hash) { YAML.load_file("#{fixtures_dir}/importer_output.yaml") }

    it 'loads parature faqs from specified resource' do
      expect(ParatureFaq).to receive(:index) do |entries|

        expect(entries.size).to eq(29)
        expect(entries).to match_array entry_hash

      end
      importer.import
    end
  end
end
