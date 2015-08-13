require 'spec_helper'

describe Envirotech::BaseData do
  let(:fixtures_file) do
    "#{Rails.root}/spec/fixtures/envirotech/base/base.json"
  end
  subject do
    base = described_class.new
    base.instance_variable_set('@resource', 'http://example.com')
    base
  end

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

    allow(agent).to receive(:get).with('http://example.com?page=1') do
      double(body: File.open(fixtures_file).read)
    end
    allow(agent).to receive(:get).with('http://example.com?page=2') do
      double(body: '[]')
    end

    agent
  end

  before { Envirotech::Login.mechanize_agent = mechanize_agent }

  describe '#fetch_data' do
    it 'is as expected' do
      expect(subject.send(:fetch_data)).to eq(JSON.parse(File.open(fixtures_file).read))
    end
  end
end
