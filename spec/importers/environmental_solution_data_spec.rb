require 'spec_helper'

describe EnvironmentalSolutionData do
  let(:fixtures_dir) { "#{File.dirname(__FILE__)}/environmental_solution" }
  let(:fixtures_file) { "#{Rails.root}/spec/fixtures/environmental_solution_articles/environmental_solution_articles.json" }

  let(:mechanize_agent) do
    agent = double('mechanize_agent')

    allow(agent).to receive(:get).with(described_class::LOGIN_URL) do
      token_form = double('password=' => 'foo', 'buttons' => [])
      double(form: token_form)
    end

    allow(agent).to receive(:submit) do
      field_with = double('value=' => nil)
      login_form = double(field_with: field_with, buttons: [])
      double(form: login_form)
    end

    allow(agent).to receive(:get).with('dummy_resource?page=1') do
      double(body: File.open(fixtures_file).read)
    end
    allow(agent).to receive(:get).with('dummy_resource?page=2') do
      double(body: '[]')
    end

    agent
  end

  let(:importer) { described_class.new('dummy_resource', mechanize_agent) }

  let(:articles_hash) { YAML.load_file("#{fixtures_dir}/environmental_solution_articles.yaml") }

  it_behaves_like 'an importer which can purge old documents'

  describe '#import' do
    it 'loads environmental_solution articles from specified resource' do
      expect(EnvironmentalSolution).to receive(:index) do |articles|
        expect(articles.size).to eq(2)
        2.times { |x| expect(articles[x]).to eq(articles_hash[x]) }
      end
      importer.import
    end
  end
end
