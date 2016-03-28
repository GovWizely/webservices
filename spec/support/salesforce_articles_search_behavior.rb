shared_context 'all Salesforce Article data' do
  include_context 'SalesforceArticle::CountryCommercial data'
  include_context 'SalesforceArticle::MarketInsight data'
  include_context 'SalesforceArticle::StateReport data'
  include_context 'SalesforceArticle::TopMarkets data'
end

class StubbedRestforce
  def initialize(query_stub)
    @query = query_stub
  end

  def query(_query_string)
    @query
  end
end

def restforce_collection(file_path)
  sobjects_hash = YAML.load_file file_path
  [Restforce::Mash.build(sobjects_hash.first, nil)]
end

shared_context 'SalesforceArticle::CountryCommercial data' do
  before(:all) do
    fixtures_path = "#{Rails.root}/spec/fixtures/salesforce_articles/country_commercial_sobjects.yml"
    client = StubbedRestforce.new(restforce_collection(fixtures_path))

    SalesforceArticle::CountryCommercial.recreate_index
    SalesforceArticle::CountryCommercialData.new(client).import

    @all_possible_full_results ||= {}
    @all_possible_full_results[SalesforceArticle::CountryCommercial] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/salesforce_articles/country_commercial/results.json",).read,)
  end
end

shared_examples 'it contains all SalesforceArticle::CountryCommercial results' do
  let(:source) { SalesforceArticle::CountryCommercial }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SalesforceArticle::CountryCommercial results that match countries "IQ"' do
  let(:source) { SalesforceArticle::CountryCommercial }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SalesforceArticle::CountryCommercial results that match topics "Trade Development and Promotion"' do
  let(:source) { SalesforceArticle::CountryCommercial }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'SalesforceArticle::MarketInsight data' do
  before(:all) do
    fixtures_path = "#{Rails.root}/spec/fixtures/salesforce_articles/market_insight_sobjects.yml"
    client = StubbedRestforce.new(restforce_collection(fixtures_path))

    SalesforceArticle::MarketInsight.recreate_index

    SalesforceArticle::MarketInsightData.new(client).import
    @all_possible_full_results ||= {}
    @all_possible_full_results[SalesforceArticle::MarketInsight] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/salesforce_articles/market_insight/results.json",).read,)
  end
end

shared_examples 'it contains all SalesforceArticle::MarketInsight results' do
  let(:source) { SalesforceArticle::MarketInsight }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SalesforceArticle::MarketInsight results that match trade_regions "European Union - 28"' do
  let(:source) { SalesforceArticle::MarketInsight }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'SalesforceArticle::StateReport data' do
  before(:all) do
    fixtures_path = "#{Rails.root}/spec/fixtures/salesforce_articles/state_report_sobjects.yml"
    client = StubbedRestforce.new(restforce_collection(fixtures_path))

    SalesforceArticle::StateReport.recreate_index
    SalesforceArticle::StateReportData.new(client).import

    @all_possible_full_results ||= {}
    @all_possible_full_results[SalesforceArticle::StateReport] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/salesforce_articles/state_report/results.json",).read,)
  end
end

shared_examples 'it contains all SalesforceArticle::StateReport results' do
  let(:source) { SalesforceArticle::StateReport }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SalesforceArticle::StateReport results that match first_published_date "2015-12-14 TO 2015-12-14"' do
  let(:source) { SalesforceArticle::StateReport }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SalesforceArticle::StateReport results that match last_published_date "2015-12-14 TO 2015-12-14"' do
  let(:source) { SalesforceArticle::StateReport }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SalesforceArticle::StateReport results that match "montana"' do
  let(:source) { SalesforceArticle::StateReport }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'SalesforceArticle::TopMarkets data' do
  before(:all) do
    fixtures_path = "#{Rails.root}/spec/fixtures/salesforce_articles/top_markets_sobjects.yml"
    client = StubbedRestforce.new(restforce_collection(fixtures_path))

    SalesforceArticle::TopMarkets.recreate_index
    SalesforceArticle::TopMarketsData.new(client).import

    @all_possible_full_results ||= {}
    @all_possible_full_results[SalesforceArticle::TopMarkets] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/salesforce_articles/top_markets/results.json",).read,)
  end
end

shared_examples 'it contains all SalesforceArticle::TopMarkets results' do
  let(:source) { SalesforceArticle::TopMarkets }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SalesforceArticle::TopMarkets results that match industry "Textiles and Apparel"' do
  let(:source) { SalesforceArticle::TopMarkets }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SalesforceArticle::TopMarkets results that match world_regions "South America"' do
  let(:source) { SalesforceArticle::TopMarkets }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end
