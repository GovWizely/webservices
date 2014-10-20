require 'spec_helper'

describe SharepointTradeArticleQuery do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/sharepoint_trade_articles" }

  describe '#generate_search_body' do

    context 'when options is an empty hash' do
      let(:query) { SharepointTradeArticleQuery.new({}) }

      it 'generates search body with default options' do
        JSON.parse(query.generate_search_body).should == {}
      end
    end

    context 'when options include title' do
      let(:query) { SharepointTradeArticleQuery.new(title: 'ata') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/queries/match_title.json").read }

      it 'generates search body with queries' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

    context 'when options include short_title' do
      let(:query) { SharepointTradeArticleQuery.new(short_title: 'ata') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/queries/match_short_title.json").read }

      it 'generates search body with queries' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

    context 'when options include summary' do
      let(:query) { SharepointTradeArticleQuery.new(summary: 'advocacy') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/queries/match_summary.json").read }

      it 'generates search body with queries' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

    context 'when options include creation_date filter' do
      let(:query) { SharepointTradeArticleQuery.new(creation_date_start: '2014-08-27', creation_date_end: '2014-08-28') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/queries/creation_date_filter.json").read }

      it 'generates search body with filters' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

    context 'when options include release_date filter' do
      let(:query) { SharepointTradeArticleQuery.new(release_date_start: '2014-08-27', release_date_end: '2014-08-28') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/queries/release_date_filter.json").read }

      it 'generates search body with filters' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

    context 'when options include expiration_date filter' do
      let(:query) { SharepointTradeArticleQuery.new(expiration_date_start: '2014-08-27', expiration_date_end: '2014-08-28') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/queries/expiration_date_filter.json").read }

      it 'generates search body with filters' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

    context 'when options include source_agencies or source_business_units or source_offices' do
      let(:query) { SharepointTradeArticleQuery.new(source_agencies: 'trade', source_business_units: 'markets', source_offices: 'director general') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/queries/match_source_agencies_fields.json").read }

      it 'generates search body with queries' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

    context 'when options include content' do
      let(:query) { SharepointTradeArticleQuery.new(content: 'foreign payment disputes') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/queries/match_content.json").read }

      it 'generates search body with queries' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

    context 'when options include keyword' do
      let(:query) { SharepointTradeArticleQuery.new(keyword: 'dispute') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/queries/match_keyword.json").read }

      it 'generates search body with queries' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

    context 'when options include export_phases' do
      let(:query) { SharepointTradeArticleQuery.new(export_phases: 'expand') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/queries/match_export_phases.json").read }

      it 'generates search body with queries' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

    context 'when options include industries' do
      let(:query) { SharepointTradeArticleQuery.new(industries: 'defense') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/queries/match_industries.json").read }

      it 'generates search body with queries' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

    context 'when options include countries' do
      let(:query) { SharepointTradeArticleQuery.new(countries: 'af,ao') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/queries/filter_countries.json").read }

      it 'generates search body with filters' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

    context 'when options include topics or subtopics' do
      let(:query) { SharepointTradeArticleQuery.new(topics: 'free trade', sub_topics: 'nafta') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/queries/match_topics_fields.json").read }

      it 'generates search body with queries' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

    context 'when options include geo_regions or geo_subregion' do
      let(:query) { SharepointTradeArticleQuery.new(geo_regions: 'asia', geo_subregions: 'east') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/queries/match_geo_regions_fields.json").read }

      it 'generates search body with queries' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

    context 'when options include trade_regions' do
      let(:query) { SharepointTradeArticleQuery.new(trade_regions: 'asia') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/queries/match_trade_regions.json").read }

      it 'generates search body with queries' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

    context 'when options include trade_programs' do
      let(:query) { SharepointTradeArticleQuery.new(trade_programs: 'advisory') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/queries/match_trade_programs.json").read }

      it 'generates search body with queries' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

    context 'when options include trade_initiatives' do
      let(:query) { SharepointTradeArticleQuery.new(trade_initiatives: 'discover') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/queries/match_trade_initiatives.json").read }

      it 'generates search body with queries' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

    context 'when options include q' do
      let(:query) { SharepointTradeArticleQuery.new(q: 'import') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/queries/match_q.json").read }

      it 'generates search body with queries' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end

  end
end
