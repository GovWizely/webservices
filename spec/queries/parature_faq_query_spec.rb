require 'spec_helper'

describe ParatureFaqQuery do
  let(:fixtures_dir) { "#{File.dirname(__FILE__)}/parature_faq" }

  describe '#generate_search_body' do
    context 'when options is an empty hash' do
      let(:query) { ParatureFaqQuery.new({}) }

      it 'generates search body with default options' do
        expect(JSON.parse(query.generate_search_body)).to eq({})
      end
    end

    context 'when options include question' do
      let(:query) { ParatureFaqQuery.new(question: 'eu') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/match_question.json").read }

      it 'generates search body with queries' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include answer' do
      let(:query) { ParatureFaqQuery.new(answer: 'certificate') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/match_answer.json").read }

      it 'generates search body with queries' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include industries' do
      let(:query) { ParatureFaqQuery.new(industries: 'importing') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/filter_industries.json").read }

      it 'generates search body with queries' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include topics' do
      let(:query) { ParatureFaqQuery.new(topics: 'cafta-dr') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/filter_topics.json").read }

      it 'generates search body with queries' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include q' do
      let(:query) { ParatureFaqQuery.new(q: 'tpcc') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/match_q.json").read }

      it 'generates search body with queries' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include countries' do
      let(:query) { ParatureFaqQuery.new(countries: 'tr,cr') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/filter_countries.json").read }

      it 'generates search body with filters' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include update_date filter' do
      let(:query) { ParatureFaqQuery.new(update_date: '2013-01-11 TO 2013-03-18') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/filter_date.json").read }

      it 'generates search body with filters' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end
  end
end
