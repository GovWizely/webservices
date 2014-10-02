require 'spec_helper'

describe FbopenLeadQuery do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/fbopen_leads" }

  describe '#new' do
    it_behaves_like 'a paginated query'

    context 'when options include industry and specific_location' do
      subject { FbopenLeadQuery.new(industry: 'asphalt', specific_location: 'US') }

      its(:industry) { should == 'asphalt' }
      its(:specific_location) { should == 'US' }
    end
  end

  describe '#generate_search_body' do
    context 'when options is an empty hash' do
      let(:query) { FbopenLeadQuery.new({}) }

      it 'generates search body with default options' do
        JSON.parse(query.generate_search_body).should == {}
      end
      it 'should be sorted by default' do
        query.sort.should == 'end_date,contract_number'
      end
    end

    context 'when options include industry' do
      let(:query) { FbopenLeadQuery.new(industry: 'fishing') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_industry.json").read }

      it 'generates search body with queries' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

    context 'when options include specific_location' do
      let(:query) { FbopenLeadQuery.new(specific_location: 'canada') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_specific_location.json").read }

      it 'generates search body with filters' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

    context 'when options include q' do
      let(:query) { FbopenLeadQuery.new(q: 'workboat') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_q.json").read }

      it 'generates search body with queries' do
        JSON.parse(query.generate_search_body).should == search_body
      end

      it 'should be sorted by relevance' do
        query.sort.should be_nil
      end
    end

    context 'when options include all :)' do
      let(:query) { FbopenLeadQuery.new(description: 'bird', title: 'roof', q: 'workboat', specific_location: 'canada', industry: 'fishing') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_all.json").read }

      it 'generates search body with queries' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end
  end
end
