require 'spec_helper'

describe BisnForeignSanctionsEvaderData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/bisn_foreign_sanctions_evaders" }
  let(:fixtures_file) { "#{fixtures_dir}/fse.xml" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/results.yaml") }

  describe '#import' do
    it 'loads foreign sanctions evaders from specified resource' do
      BisnForeignSanctionsEvader.should_receive(:index) do |fse|
        fse.should == expected
      end
      importer.import
    end
  end
end
