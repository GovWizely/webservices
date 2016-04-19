shared_context 'all Salesforce Article data' do
  include_context 'SalesforceArticle::CountryCommercial data'
  include_context 'SalesforceArticle::MarketInsight data'
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
  sobjects = YAML.load_file file_path
  sobjects.map { |sobject| Restforce::Mash.build(sobject, nil) }
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

shared_examples 'it contains all SalesforceArticle::CountryCommercial results that match "rice"' do
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

shared_examples 'it contains all SalesforceArticle::MarketInsight results that match world_regions "Europe"' do
  let(:source) { SalesforceArticle::MarketInsight }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SalesforceArticle::MarketInsight results that match industries "Higher Education"' do
  let(:source) { SalesforceArticle::MarketInsight }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end
