require 'spec_helper'

describe SharepointTradeArticleQuery do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/sharepoint_trade_articles" }

  describe '#generate_search_body' do

    context 'when options is an empty hash' do
      let(:query) { SharepointTradeArticleQuery.new({}) }

      it 'generates search body with default options' do
        expect(JSON.parse(query.generate_search_body)).to eq({})
      end
    end

    context 'when options include creation_date filter' do
      let(:query) { SharepointTradeArticleQuery.new(creation_date_start: '2014-08-27', creation_date_end: '2014-08-28') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/queries/creation_date_filter.json").read }

      it 'generates search body with filters' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include release_date filter' do
      let(:query) { SharepointTradeArticleQuery.new(release_date_start: '2014-08-27', release_date_end: '2014-08-28') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/queries/release_date_filter.json").read }

      it 'generates search body with filters' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include expiration_date filter' do
      let(:query) { SharepointTradeArticleQuery.new(expiration_date_start: '2014-08-27', expiration_date_end: '2014-08-28') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/queries/expiration_date_filter.json").read }

      it 'generates search body with filters' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include export_phases' do
      let(:query) { SharepointTradeArticleQuery.new(export_phases: 'expand,learn') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/queries/filter_export_phases.json").read }

      it 'generates search body with queries' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include industries' do
      let(:query) { SharepointTradeArticleQuery.new(industries: 'agribusniess,aerospace & defense') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/queries/filter_industries.json").read }

      it 'generates search body with queries' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include countries' do
      let(:query) { SharepointTradeArticleQuery.new(countries: 'af,ao') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/queries/filter_countries.json").read }

      it 'generates search body with filters' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include topics or subtopics' do
      let(:query) { SharepointTradeArticleQuery.new(topics: 'free trade agreements', sub_topics: 'nafta,cafta-dr') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/queries/filter_topics_fields.json").read }

      it 'generates search body with queries' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include geo_regions or geo_subregion' do
      let(:query) { SharepointTradeArticleQuery.new(geo_regions: 'asia', geo_subregions: 'east asia,asia pacific') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/queries/filter_geo_regions_fields.json").read }

      it 'generates search body with queries' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include trade_regions' do
      let(:query) { SharepointTradeArticleQuery.new(trade_regions: 'andean community,african growth and opportunity act') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/queries/filter_trade_regions.json").read }

      it 'generates search body with queries' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include trade_programs' do
      let(:query) { SharepointTradeArticleQuery.new(trade_programs: 'advocacy,advisory committees') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/queries/filter_trade_programs.json").read }

      it 'generates search body with queries' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include trade_initiatives' do
      let(:query) { SharepointTradeArticleQuery.new(trade_initiatives: 'discover global markets') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/queries/filter_trade_initiatives.json").read }

      it 'generates search body with queries' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include q' do
      let(:query) { SharepointTradeArticleQuery.new(q: 'import') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/queries/match_q.json").read }

      it 'generates search body with queries' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

  end
end
