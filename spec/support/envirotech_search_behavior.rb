shared_context 'all Envirotech fixture data' do
  include_context 'Envirotech::Issue data'
  include_context 'Envirotech::Solution data'
  include_context 'Envirotech::Regulation data'
  include_context 'Envirotech::Provider data'
  include_context 'Envirotech::AnalysisLink data'
  include_context 'Envirotech::BackgroundLink data'
  include_context 'Envirotech::ProviderSolution data'
  include_context 'Envirotech::Relational data'
  before do
    allow(Date).to receive(:current).and_return(Date.parse('2013-01-11'))
  end
end

shared_context 'empty Envirotech indices' do
  before(:all) do
    %w(Issue Solution Regulation Provider
       AnalysisLink BackgroundLink ProviderSolution).each do |model_name|
      "Envirotech::#{model_name}".constantize.recreate_index
    end
  end
end

shared_context 'Envirotech::Solution data' do
  before(:all) do
    Envirotech::Solution.recreate_index

    relational_fixtures_file = "#{Rails.root}/spec/fixtures/envirotech/relations_data/issue_solution_regulation.json"
    relational_data = JSON.parse(open(relational_fixtures_file).read)
    Envirotech::RelationalData.relations = relational_data

    fixtures_file = "#{Rails.root}/spec/fixtures/envirotech/solution_articles/solution_articles.json"
    Envirotech::SolutionData.new(fixtures_file).import

    @all_possible_full_results ||= {}
    @all_possible_full_results[Envirotech::Solution] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/envirotech/solution/all_results.json").read)
  end
end

shared_examples 'it contains all Envirotech::Solution results' do
  let(:source) { Envirotech::Solution }
  let(:expected) { [0, 1] }
  it_behaves_like 'it contains all expected results without source'
end

shared_examples 'it contains all Envirotech::Solution results that match "Precipitadores"' do
  let(:source) { Envirotech::Solution }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results without source'
end

shared_examples 'it contains all Envirotech::Solution results matches a query with stemming/folding' do
  let(:source) { Envirotech::Solution }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results without source'
end

shared_examples 'it contains all Envirotech::Solution results matches a query with Chinese character' do
  let(:source) { Envirotech::Solution }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results without source'
end

shared_examples 'it contains all Envirotech::Solution results that match source_id 201' do
  let(:source) { Envirotech::Solution }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results without source'
end

shared_context 'Envirotech::Issue data' do
  before(:all) do
    Envirotech::Issue.recreate_index
    fixtures_file = "#{Rails.root}/spec/fixtures/envirotech/issue_articles/issue_articles.json"
    Envirotech::IssueData.new(fixtures_file).import

    @all_possible_full_results ||= {}
    @all_possible_full_results[Envirotech::Issue] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/envirotech/issue/all_results.json").read)
  end
end

shared_examples 'it contains all Envirotech::Issue results' do
  let(:source) { Envirotech::Issue }
  let(:expected) { [0, 1] }
  it_behaves_like 'it contains all expected results without source'
end

shared_examples 'it contains all Envirotech::Issue results that match "passivel"' do
  let(:source) { Envirotech::Issue }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results without source'
end

shared_examples 'it contains all Envirotech::Issue results matches a query with Chinese character' do
  let(:source) { Envirotech::Issue }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results without source'
end

shared_examples 'it contains all Envirotech::Issue results that match source_id 23' do
  let(:source) { Envirotech::Issue }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results without source'
end

shared_examples 'it contains all Envirotech::Issue results that match regulation_ids 19' do
  let(:source) { Envirotech::Issue }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results without source'
end

shared_context 'Envirotech::Regulation data' do
  before(:all) do
    Envirotech::Regulation.recreate_index

    relational_fixtures_file = "#{Rails.root}/spec/fixtures/envirotech/relations_data/issue_solution_regulation.json"
    relational_data = JSON.parse(open(relational_fixtures_file).read)
    Envirotech::RelationalData.relations = relational_data

    fixtures_file = "#{Rails.root}/spec/fixtures/envirotech/regulation_articles/regulation_articles.json"
    Envirotech::RegulationData.new(fixtures_file).import

    @all_possible_full_results ||= {}
    @all_possible_full_results[Envirotech::Regulation] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/envirotech/regulation/all_results.json").read)
  end
end

shared_examples 'it contains all Envirotech::Regulation results' do
  let(:source) { Envirotech::Regulation }
  let(:expected) { [0, 1] }
  it_behaves_like 'it contains all expected results without source'
end

shared_examples 'it contains all Envirotech::Regulation results that match "dechets"' do
  let(:source) { Envirotech::Regulation }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results without source'
end

shared_examples 'it contains all Envirotech::Regulation results matches a query with Chinese character' do
  let(:source) { Envirotech::Regulation }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results without source'
end

shared_examples 'it contains all Envirotech::Regulation results that match source_id 19' do
  let(:source) { Envirotech::Regulation }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results without source'
end

shared_context 'Envirotech::Provider data' do
  before(:all) do
    Envirotech::Provider.recreate_index
    fixtures_file = "#{Rails.root}/spec/fixtures/envirotech/provider_articles/provider_articles.json"
    Envirotech::ProviderData.new(fixtures_file).import

    @all_possible_full_results ||= {}
    @all_possible_full_results[Envirotech::Provider] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/envirotech/provider/all_results.json").read)
  end
end

shared_examples 'it contains all Envirotech::Provider results' do
  let(:source) { Envirotech::Provider }
  let(:expected) { [0, 1] }
  it_behaves_like 'it contains all expected results without source'
end

shared_examples 'it contains all Envirotech::Provider results that match "Corporation"' do
  let(:source) { Envirotech::Provider }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results without source'
end

shared_examples 'it contains all Envirotech::Provider results that match source_id 984' do
  let(:source) { Envirotech::Provider }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results without source'
end

shared_context 'Envirotech::AnalysisLink data' do
  before(:all) do
    Envirotech::AnalysisLink.recreate_index
    fixtures_file = "#{Rails.root}/spec/fixtures/envirotech/analysis_link_articles/analysis_link_articles.json"
    Envirotech::AnalysisLinkData.new(fixtures_file).import

    @all_possible_full_results ||= {}
    @all_possible_full_results[Envirotech::AnalysisLink] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/envirotech/analysis_link/all_results.json").read)
  end
end

shared_examples 'it contains all Envirotech::AnalysisLink results' do
  let(:source) { Envirotech::AnalysisLink }
  let(:expected) { [0, 1] }
  it_behaves_like 'it contains all expected results without source'
end

shared_examples 'it contains all Envirotech::AnalysisLink results that match "Metodos"' do
  let(:source) { Envirotech::AnalysisLink }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results without source'
end

shared_examples 'it contains all Envirotech::AnalysisLink results that match source_id 10' do
  let(:source) { Envirotech::AnalysisLink }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results without source'
end

shared_examples 'it contains all Envirotech::AnalysisLink results that match issue_id 19' do
  let(:source) { Envirotech::AnalysisLink }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results without source'
end

shared_context 'Envirotech::BackgroundLink data' do
  before(:all) do
    Envirotech::BackgroundLink.recreate_index
    fixtures_file = "#{Rails.root}/spec/fixtures/envirotech/background_link_articles/background_link_articles.json"
    Envirotech::BackgroundLinkData.new(fixtures_file).import

    @all_possible_full_results ||= {}
    @all_possible_full_results[Envirotech::BackgroundLink] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/envirotech/background_link/all_results.json").read)
  end
end

shared_examples 'it contains all Envirotech::BackgroundLink results' do
  let(:source) { Envirotech::BackgroundLink }
  let(:expected) { [0, 1] }
  it_behaves_like 'it contains all expected results without source'
end

shared_examples 'it contains all Envirotech::BackgroundLink results that match "Protecao"' do
  let(:source) { Envirotech::BackgroundLink }
  let(:expected) { [0, 1] }
  it_behaves_like 'it contains all expected results without source'
end

shared_examples 'it contains all Envirotech::BackgroundLink results that match source_id 1' do
  let(:source) { Envirotech::BackgroundLink }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results without source'
end

shared_examples 'it contains all Envirotech::BackgroundLink results that match issue_id 16' do
  let(:source) { Envirotech::BackgroundLink }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results without source'
end

shared_context 'Envirotech::ProviderSolution data' do
  before(:all) do
    Envirotech::ProviderSolution.recreate_index
    fixtures_file = "#{Rails.root}/spec/fixtures/envirotech/provider_solution_articles/provider_solution_articles.json"
    Envirotech::ProviderSolutionData.new(fixtures_file).import

    @all_possible_full_results ||= {}
    @all_possible_full_results[Envirotech::ProviderSolution] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/envirotech/provider_solution/all_results.json").read)
  end
end

shared_examples 'it contains all Envirotech::ProviderSolution results' do
  let(:source) { Envirotech::ProviderSolution }
  let(:expected) { [0, 1] }
  it_behaves_like 'it contains all expected results without source'
end

shared_examples 'it contains all Envirotech::ProviderSolution results that match source_id 422' do
  let(:source) { Envirotech::ProviderSolution }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results without source'
end

shared_examples 'it contains all Envirotech::ProviderSolution results that match solution_id 196' do
  let(:source) { Envirotech::ProviderSolution }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results without source'
end

shared_examples 'it contains all Envirotech::ProviderSolution results that match provider_id 931' do
  let(:source) { Envirotech::ProviderSolution }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results without source'
end

shared_examples 'it contains all Envirotech::ProviderSolution results that match provider_id 931 and solution_id 128' do
  let(:source) { Envirotech::ProviderSolution }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results without source'
end

shared_context 'Envirotech::Relational data' do
  before(:all) do
    relational_fixtures_file = "#{Rails.root}/spec/fixtures/envirotech/relations_data/issue_solution_regulation.json"
    relational_data = JSON.parse(open(relational_fixtures_file).read)
    Envirotech::RelationalData.relations = relational_data

    Envirotech::RelationalData.new.import
  end
end
