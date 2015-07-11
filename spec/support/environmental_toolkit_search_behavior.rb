shared_context 'all Environmental Toolkit fixture data' do
  include_context 'EnvironmentalToolkit::EnvironmentalSolution data'
end

shared_context 'all Environmental Toolkit v2 fixture data' do
  include_context 'EnvironmentalToolkit::EnvironmentalSolution data v2'
end

shared_context 'EnvironmentalToolkit::EnvironmentalSolution data' do
  before do
    EnvironmentalToolkit::EnvironmentalSolution.recreate_index
    fixtures_file =  "#{Rails.root}/spec/fixtures/environmental_toolkit/environmental_solution_articles/environmental_solution_articles.json"
    allow_any_instance_of(EnvironmentalToolkit::EnvironmentalSolutionData).to receive(:fetch_data).and_return(JSON.parse File.open(fixtures_file).read)
    EnvironmentalToolkit::EnvironmentalSolutionData.new(fixtures_file).import

    @all_possible_full_results ||= {}
    @all_possible_full_results[EnvironmentalToolkit::EnvironmentalSolution] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/environmental_toolkit/environmental_solution/all_results.json").read)

    allow(Date).to receive(:current).and_return(Date.parse('2013-01-11'))
  end
end

shared_context 'EnvironmentalToolkit::EnvironmentalSolution data v2' do
  before do
    EnvironmentalToolkit::EnvironmentalSolution.recreate_index
    fixtures_file =  "#{Rails.root}/spec/fixtures/environmental_toolkit/environmental_solution_articles/environmental_solution_articles.json"
    allow_any_instance_of(EnvironmentalToolkit::EnvironmentalSolutionData).to receive(:fetch_data).and_return(JSON.parse File.open(fixtures_file).read)
    EnvironmentalToolkit::EnvironmentalSolutionData.new(fixtures_file).import

    @all_possible_full_results ||= {}
    @all_possible_full_results[EnvironmentalToolkit::EnvironmentalSolution] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/environmental_toolkit/environmental_solution/all_results.json").read)

    allow(Date).to receive(:current).and_return(Date.parse('2013-01-11'))
  end
end

shared_examples 'it contains all EnvironmentalToolkit::EnvironmentalSolution results' do
  let(:source) { EnvironmentalToolkit::EnvironmentalSolution }
  let(:expected) { [0, 1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all EnvironmentalToolkit::EnvironmentalSolution results that match "Precipitadores"' do
  let(:source) { EnvironmentalToolkit::EnvironmentalSolution }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all EnvironmentalToolkit::EnvironmentalSolution results matches a query with stemming/folding' do
  let(:source) { EnvironmentalToolkit::EnvironmentalSolution }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all EnvironmentalToolkit::EnvironmentalSolution results matches a query with Chinese character' do
  let(:source) { EnvironmentalToolkit::EnvironmentalSolution }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results of source'
end
