shared_context 'all Envirotech fixture data' do
  include_context 'Envirotech::Solution data'
  include_context 'Envirotech::Issue data'
  include_context 'Envirotech::Regulation data'
end

shared_context 'all Envirotech v2 fixture data' do
  include_context 'Envirotech::Solution data'
  include_context 'Envirotech::Issue data'
  include_context 'Envirotech::Regulation data'
end

shared_context 'Envirotech::Solution data' do
  before do
    Envirotech::Solution.recreate_index
    fixtures_file = "#{Rails.root}/spec/fixtures/envirotech/solution_articles/solution_articles.json"
    allow_any_instance_of(Envirotech::SolutionData).to receive(:fetch_data).and_return(JSON.parse File.open(fixtures_file).read)
    Envirotech::SolutionData.new(fixtures_file).import

    @all_possible_full_results ||= {}
    @all_possible_full_results[Envirotech::Solution] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/envirotech/solution/all_results.json").read)

    allow(Date).to receive(:current).and_return(Date.parse('2013-01-11'))
  end
end

shared_examples 'it contains all Envirotech::Solution results' do
  let(:source) { Envirotech::Solution }
  let(:expected) { [0, 1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all Envirotech::Solution results that match "Precipitadores"' do
  let(:source) { Envirotech::Solution }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all Envirotech::Solution results matches a query with stemming/folding' do
  let(:source) { Envirotech::Solution }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all Envirotech::Solution results matches a query with Chinese character' do
  let(:source) { Envirotech::Solution }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results of source'
end


shared_context 'Envirotech::Issue data' do
  before do
    Envirotech::Issue.recreate_index
    fixtures_file = "#{Rails.root}/spec/fixtures/envirotech/issue_articles/issue_articles.json"
    allow_any_instance_of(Envirotech::IssueData).to receive(:fetch_data).and_return(JSON.parse File.open(fixtures_file).read)
    Envirotech::IssueData.new(fixtures_file).import

    @all_possible_full_results ||= {}
    @all_possible_full_results[Envirotech::Issue] = JSON.parse(open(
                                                                 "#{File.dirname(__FILE__)}/envirotech/issue/all_results.json").read)

    allow(Date).to receive(:current).and_return(Date.parse('2013-01-11'))
  end
end

shared_examples 'it contains all Envirotech::Issue results' do
  let(:source) { Envirotech::Issue }
  let(:expected) { [0, 1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all Envirotech::Issue results that match "passivel"' do
  let(:source) { Envirotech::Issue }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all Envirotech::Issue results matches a query with Chinese character' do
  let(:source) { Envirotech::Issue }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'Envirotech::Regulation data' do
  before do
    Envirotech::Regulation.recreate_index
    fixtures_file = "#{Rails.root}/spec/fixtures/envirotech/regulation_articles/regulation_articles.json"
    allow_any_instance_of(Envirotech::RegulationData).to receive(:fetch_data).and_return(JSON.parse File.open(fixtures_file).read)
    Envirotech::RegulationData.new(fixtures_file).import

    @all_possible_full_results ||= {}
    @all_possible_full_results[Envirotech::Regulation] = JSON.parse(open(
                                                                 "#{File.dirname(__FILE__)}/envirotech/regulation/all_results.json").read)

    allow(Date).to receive(:current).and_return(Date.parse('2013-01-11'))
  end
end

shared_examples 'it contains all Envirotech::Regulation results' do
  let(:source) { Envirotech::Regulation }
  let(:expected) { [0, 1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all Envirotech::Regulation results that match "dechets"' do
  let(:source) { Envirotech::Regulation }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all Envirotech::Regulation results matches a query with Chinese character' do
  let(:source) { Envirotech::Regulation }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end
