require 'spec_helper'

describe V2::TradeLead::Query do
  let(:fixtures_dir) { "#{File.dirname(__FILE__)}/query" }

  describe '#generate_search_body' do
    context 'when option is an empty hash' do
      let(:query) { described_class.new }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_default_options.json").read }

      it 'generates search body with default options' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end
  end
end
