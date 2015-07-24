require 'spec_helper'

describe Envirotech::RegulationData do
  let(:fixtures_dir) { "#{File.dirname(__FILE__)}/regulation" }
  let(:fixtures_file) { "#{Rails.root}/spec/fixtures/envirotech/regulation_articles/regulation_articles.json" }

  let(:mechanize_agent) do
    agent = double('mechanize_agent')

    allow(agent).to receive(:get).with(Envirotech::Login::LOGIN_URL) do
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

  let(:importer) { described_class.new('dummy_resource') }

  let(:articles_hash) { YAML.load_file("#{fixtures_dir}/regulation_articles.yaml") }

  before { Envirotech::Login.mechanize_agent = mechanize_agent }

  it_behaves_like 'an importer which can purge old documents'

  describe '#import' do
    it 'loads regulation articles from specified resource' do
      expect(Envirotech::Regulation).to receive(:index) do |articles|
        expect(articles.size).to eq(2)
        2.times { |x| expect(articles[x]).to eq(articles_hash[x]) }
      end
      importer.import
    end
  end
end
