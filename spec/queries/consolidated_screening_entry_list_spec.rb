require 'spec_helper'

describe ConsolidatedScreeningListQuery do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/consolidated_screening_list" }

  describe '#new' do
    it_behaves_like 'a paginated query'

    context 'when options include countries' do
      subject { described_class.new(countries: 'us,ca') }

      its(:countries) { should == %w(US CA) }
    end
  end

  describe '#generate_search_body' do

    context 'when options include only q' do
      let(:query) { described_class.new(q: 'fish') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_multi_match.json").read }

      it 'generates search body with q query' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

    context 'when options include only sdn_type' do
      let(:query) { described_class.new(sdn_type: 'Entity') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_sdn_type_filter.json").read }

      it 'generates search body with sdn_type filter' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

    context 'when options include only sources' do
      let(:query) { described_class.new(sources: 'SDN') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_sources_filter.json").read }

      it 'generates search body with sdn_type filter' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

    context 'when options include only countries' do
      let(:query) { described_class.new(countries: 'us,ca') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_countries_filter.json").read }

      it 'generates search body with countries filter' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

    context 'when options include all possible fields' do
      let(:query) { described_class.new(countries: 'us,ca',
                                        q: 'fish',
                                        sources: 'SDN',
                                        sdn_type: 'Entity') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_all.json").read }

      it 'generates search body with countries filter' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end
  end
end
