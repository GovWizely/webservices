require 'spec_helper'

describe MarketResearchQuery do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/parature_faqs" }

  describe '#generate_search_body' do

    context 'when options is an empty hash' do
      let(:query) { ParatureFaqQuery.new({}) }

      it 'generates search body with default options' do
        JSON.parse(query.generate_search_body).should == {}
      end
    end

    context 'when options include question' do
      let(:query) { ParatureFaqQuery.new(question: 'eu') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_match_question.json").read }

      it 'generates search body with queries' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

    context 'when options include answer' do
      let(:query) { ParatureFaqQuery.new(answer: 'certificate') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_match_answer.json").read }

      it 'generates search body with queries' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

    context 'when options include industry' do
      let(:query) { ParatureFaqQuery.new(industry: 'importing') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_match_industry.json").read }

      it 'generates search body with queries' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

    context 'when options include q' do
      let(:query) { ParatureFaqQuery.new(q: 'tpcc') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_multi_match.json").read }

      it 'generates search body with queries' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

    context 'when options include countries' do
      let(:query) { ParatureFaqQuery.new(countries: 'tr,cr') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_filter_countries.json").read }

      it 'generates search body with filters' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

    context 'when options include update_date filter' do
      let(:query) { ParatureFaqQuery.new(update_date_start: '2013-01-11', update_date_end: '2013-03-18') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_filter_date.json").read }

      it 'generates search body with filters' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

  end
end
