require 'spec_helper'

describe ItaTaxonomyQuery do
  let(:fixtures_dir) { "#{File.dirname(__FILE__)}/ita_taxonomy" }

  describe '#generate_search_body' do
    context 'when options is an empty hash' do
      let(:query) { ItaTaxonomyQuery.new({}) }

      it 'generates search body with default options' do
        expect(JSON.parse(query.generate_search_body)).to eq({})
      end
    end

    context 'when options include q' do
      let(:query) { ItaTaxonomyQuery.new(q: 'algeria') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_q.json").read }

      it 'generates search body with queries' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include taxonomies' do
      let(:query) { ItaTaxonomyQuery.new(taxonomies: 'industries') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_taxonomies.json").read }

      it 'generates search body with queries' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end
  end
end
