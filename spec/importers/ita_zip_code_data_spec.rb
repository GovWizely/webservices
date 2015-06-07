require 'spec_helper'

describe ItaZipCodeData do
  before { ItaZipCode.recreate_index }
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/ita_zip_codes/" }
  let(:zip_resource) { "#{fixtures_dir}/zip_codes.xml" }
  let(:post_resource) { "#{fixtures_dir}/posts.xml" }
  let(:importer) { ItaZipCodeData.new(post_resource, zip_resource) }

  it_behaves_like 'an importer which can purge old documents'

  describe '#import' do
    let(:entry_hash) { YAML.load_file("#{File.dirname(__FILE__)}/ita_zip_code/results.yaml") }

    it 'loads zip_code entries from specified resource' do
      expect(ItaZipCode).to receive(:index) do |entries|
        expect(entries.size).to eq(2)
        expect(entries).to match_array entry_hash
      end
      importer.import
    end
  end
end
