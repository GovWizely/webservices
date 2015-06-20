require 'spec_helper'

describe ItaZipCodeData do
  before { ItaZipCode.recreate_index }
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/ita_zip_codes/" }
  let(:zip_resource) { "#{fixtures_dir}/zip_codes.xml" }
  let(:post_resource) { "#{fixtures_dir}/posts.xml" }
  let(:importer) { ItaZipCodeData.new(post_resource, zip_resource) }
  let(:expected) { YAML.load_file("#{File.dirname(__FILE__)}/ita_zip_code/results.yaml") }

  it_behaves_like 'an importer which can purge old documents'
  it_behaves_like 'an importer which indexes the correct documents'
end
