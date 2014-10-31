require 'spec_helper'

describe CanadaLeadQuery do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/canada_leads" }

  describe '#new' do
    it_behaves_like 'a paginated query'

    context 'when options include industry and specific_location' do
      subject { CanadaLeadQuery.new(industry: 'asphalt', specific_location: 'canada') }

      describe '#industry' do
        subject { super().industry }
        it { is_expected.to eq('asphalt') }
      end

      describe '#specific_location' do
        subject { super().specific_location }
        it { is_expected.to eq('canada') }
      end
    end
  end

  describe '#generate_search_body' do
    context 'when options is an empty hash' do
      let(:query) { CanadaLeadQuery.new({}) }

      it 'generates search body with default options' do
        expect(JSON.parse(query.generate_search_body)).to eq({})
      end
    end

    context 'when options include industry' do
      let(:query) { CanadaLeadQuery.new(industry: 'fishing') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_industry.json").read }

      it 'generates search body with queries' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include specific_location' do
      let(:query) { CanadaLeadQuery.new(specific_location: 'canada') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_specific_location.json").read }

      it 'generates search body with filters' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include q' do
      let(:query) { CanadaLeadQuery.new(q: 'workboat') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_q.json").read }

      it 'generates search body with queries' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include all :)' do
      let(:query) { CanadaLeadQuery.new(description: 'bird', title: 'roof', q: 'workboat', specific_location: 'canada', industry: 'fishing') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_all.json").read }

      it 'generates search body with queries' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end
  end
end
