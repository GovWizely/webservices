require 'spec_helper'

describe 'Consolidated Market Intelligence API', type: :request do
  include_context 'V2 headers'
  include_context 'all Salesforce Article data'

  describe 'GET /market_intelligence/search' do
    let(:params) { { size: 100 } }
    before { get '/v2/market_intelligence/search', params, @v2_headers }
    subject { response }

    context 'when search parameters are empty' do
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all SalesforceArticle::CountryCommercial results'
      it_behaves_like 'it contains all SalesforceArticle::MarketInsight results'
      it_behaves_like 'it contains all SalesforceArticle::StateReport results'
      it_behaves_like 'it contains all SalesforceArticle::TopMarkets results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) do
          [SalesforceArticle::CountryCommercial, SalesforceArticle::MarketInsight,
           SalesforceArticle::StateReport, SalesforceArticle::TopMarkets,]
        end
      end
      it_behaves_like 'it contains all expected aggregations' do
        let(:expected_json) { 'salesforce_articles/all_sources/aggregations.json' }
      end
    end

    context 'when q is specified' do
      context 'and is "montana"' do
        let(:params) { { q: 'montana' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all SalesforceArticle::StateReport results that match "montana"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [SalesforceArticle::StateReport] }
        end
        it_behaves_like 'it contains all expected aggregations' do
          let(:expected_json) { 'salesforce_articles/all_sources/aggregations_with_query_montana.json' }
        end
      end
      it_behaves_like "an empty result when a query doesn't match any documents"
    end

    context 'when countries is specified' do
      context 'and is "IQ"' do
        let(:params) { { countries: 'IQ' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all SalesforceArticle::CountryCommercial results that match countries "IQ"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [SalesforceArticle::CountryCommercial] }
        end
        it_behaves_like 'it contains all expected aggregations' do
          let(:expected_json) { 'salesforce_articles/all_sources/aggregations_with_countries_iq.json' }
        end
      end
      it_behaves_like "an empty result when a countries search doesn't match any documents"
    end

    context 'when industries is specified' do
      let(:params) { { industries: 'Textiles and Apparel' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all SalesforceArticle::TopMarkets results that match industry "Textiles and Apparel"'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [SalesforceArticle::TopMarkets] }
      end
      it_behaves_like 'it contains all expected aggregations' do
        let(:expected_json) { 'salesforce_articles/all_sources/aggregations_with_industries.json' }
      end
      it_behaves_like "an empty result when an industries search doesn't match any documents"
    end

    context 'when topics is specified' do
      let(:params) { { topics: 'Trade Development and Promotion' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all SalesforceArticle::CountryCommercial results that match topics "Trade Development and Promotion"'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [SalesforceArticle::CountryCommercial] }
      end
      it_behaves_like 'it contains all expected aggregations' do
        let(:expected_json) { 'salesforce_articles/all_sources/aggregations_with_topics.json' }
      end
      it_behaves_like "an empty result when an industries search doesn't match any documents"
    end

    context 'when sources is specified' do
      context 'and is set to "country_commercial"' do
        let(:params) { { sources: 'country_commercial' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all SalesforceArticle::CountryCommercial results'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [SalesforceArticle::CountryCommercial] }
        end
      end
      context 'and is set to "market_insight"' do
        let(:params) { { sources: 'market_insight' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all SalesforceArticle::MarketInsight results'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [SalesforceArticle::MarketInsight] }
        end
      end
      context 'and is set to "state_report"' do
        let(:params) { { sources: 'state_report' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all SalesforceArticle::StateReport results'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [SalesforceArticle::StateReport] }
        end
      end
      context 'and is set to "top_markets"' do
        let(:params) { { sources: 'top_markets' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all SalesforceArticle::TopMarkets results'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [SalesforceArticle::TopMarkets] }
        end
      end
    end

    context 'when first_published_date is specified' do
      let(:params) { { sources: 'state_report', first_published_date: '2015-12-14 TO 2015-12-14' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all SalesforceArticle::StateReport results that match first_published_date "2015-12-14 TO 2015-12-14"'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [SalesforceArticle::StateReport] }
      end
      it_behaves_like 'it contains all expected aggregations' do
        let(:expected_json) { 'salesforce_articles/all_sources/aggregations_with_first_published_date.json' }
      end
    end

    context 'when last_published_date is specified' do
      let(:params) { { sources: 'state_report', last_published_date: '2015-12-14 TO 2015-12-14' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all SalesforceArticle::StateReport results that match last_published_date "2015-12-14 TO 2015-12-14"'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [SalesforceArticle::StateReport] }
      end
      it_behaves_like 'it contains all expected aggregations' do
        let(:expected_json) { 'salesforce_articles/all_sources/aggregations_with_last_published_date.json' }
      end
    end

    context 'when trade_regions is specified' do
      let(:params) { { sources: 'market_insight', trade_regions: 'European Union - 28' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all SalesforceArticle::MarketInsight results that match trade_regions "European Union - 28"'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [SalesforceArticle::MarketInsight] }
      end
    end

    context 'when world_regions is specified' do
      let(:params) { { sources: 'top_markets', world_regions: 'South America' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all SalesforceArticle::TopMarkets results that match world_regions "South America"'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [SalesforceArticle::TopMarkets] }
      end
    end
  end
end
