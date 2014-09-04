require 'spec_helper'

describe TradeLeadQuery do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/trade_leads" }

  describe '#new' do
    it_behaves_like 'a paginated query'

    context 'when options include countries' do
      subject { TradeLeadQuery.new(countries: 'us,ca') }

      its(:countries) { should == %w(US CA) }
    end

    context 'when options does not include q' do
      subject { TradeLeadQuery.new(countries: 'us,ca') }

      its(:sort) { should eq 'publish_date:desc,country:asc' }
    end
  end

  describe '#generate_search_body' do
    context 'when options include only countries' do
      let(:query) { TradeLeadQuery.new({countries: 'ae,au' }) }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_country_filter.json").read }

      it 'generates search body with countries filter' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

    context 'when options include only q' do
      let(:query) { TradeLeadQuery.new({ q: 'water' }) }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_multi_match.json").read }

      it 'generates search body with countries filter' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

    context 'when options include countries and q' do
      let(:query) { TradeLeadQuery.new({ countries: 'au, ae', q: 'water' }) }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_multi_match_and_filter.json").read }

      it 'generates search body with countries filter' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end
  end
end
