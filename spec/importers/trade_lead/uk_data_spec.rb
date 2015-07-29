require 'spec_helper'

describe TradeLead::UkData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/trade_leads/uk" }
  let(:importer) { described_class.new(fixtures_file) }

  context 'with only open leads in XML' do
    let(:fixtures_file) { "#{fixtures_dir}/Notices.xml" }
    let(:expected) { YAML.load_file("#{File.dirname(__FILE__)}/uk/results.yaml") }

    it_behaves_like 'an importer which can purge old documents'
    it_behaves_like 'an importer which indexes the correct documents'
  end

  context 'with a closed lead in XML' do
    let(:fixtures_file) { "#{fixtures_dir}/Closed.xml" }
    let(:expected) { YAML.load_file("#{File.dirname(__FILE__)}/uk/results.yaml") }

    it 'indexes the correct documents' do
      expect { importer.import }.to raise_error
    end
  end
end
