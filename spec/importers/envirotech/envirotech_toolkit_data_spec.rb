require 'spec_helper'

describe Envirotech::EnvirotechToolkitData do
  let(:importer) { described_class.new }

  before do
    allow_any_instance_of(Envirotech::IssueData).to receive(:fetch_data).and_return({})
    allow_any_instance_of(Envirotech::Issue).to receive(:index)
    allow_any_instance_of(Envirotech::BackgroundLinkData).to receive(:fetch_data).and_return({})
    allow_any_instance_of(Envirotech::BackgroundLink).to receive(:index)
    allow_any_instance_of(Envirotech::AnalysisLinkData).to receive(:fetch_data).and_return({})
    allow_any_instance_of(Envirotech::AnalysisLink).to receive(:index)
    allow_any_instance_of(Envirotech::ProviderData).to receive(:fetch_data).and_return({})
    allow_any_instance_of(Envirotech::Provider).to receive(:index)
    allow_any_instance_of(Envirotech::ProviderSolutionData).to receive(:fetch_data).and_return({})
    allow_any_instance_of(Envirotech::ProviderSolution).to receive(:index)
    allow_any_instance_of(Envirotech::RegulationData).to receive(:fetch_data).and_return({})
    allow_any_instance_of(Envirotech::Regulation).to receive(:index)
    allow_any_instance_of(Envirotech::SolutionData).to receive(:fetch_data).and_return({})
    allow_any_instance_of(Envirotech::Solution).to receive(:index)

    scraper = double('Envirotech::ToolkitScraper')
    allow(Envirotech::ToolkitScraper).to receive(:new).and_return(scraper)
    allow(scraper).to receive(:all_issue_info).and_return(all_issue_info)
    allow(JSON).to receive(:parse).and_return(local_data)

    regulation_importer = double('Envirotech::RegulationData')
    allow(Envirotech::RegulationData).to receive(:new).and_return(regulation_importer)
    allow(regulation_importer).to receive(:import)

    solution_importer = double('Envirotech::SolutionData')
    allow(Envirotech::SolutionData).to receive(:new).and_return(solution_importer)
    allow(solution_importer).to receive(:import)
  end

  describe '#import' do
    context 'scraper working as expected' do
      let(:all_issue_info) { { dummy: 1 } }
      let(:local_data) { { 'dummy' => 1 } }
      it 'create importers with relation_data' do
        expect(Envirotech::RegulationData).to receive(:new).with(relation_data: all_issue_info)
        expect(Envirotech::SolutionData).to receive(:new).with(relation_data: all_issue_info)
        importer.import
      end
    end

    context 'scraper working as expected' do
      let(:all_issue_info) { { dummy: 1 } }
      let(:local_data) { { 'dummy' => 2 } }
      it 'notify Airbrake when data mismatch' do
        expect(Airbrake).to receive(:notify).with(Exceptions::EnvirotechToolkitDataMismatch.new)
        importer.import
      end
    end

    context 'scraper working as expected' do
      let(:all_issue_info) { }
      let(:local_data) { { 'dummy' => 2 } }
      it 'notify Airbrake when UI tool disappear' do
        expect(Airbrake).to receive(:notify).with(Exceptions::EnvirotechToolkitNotFound.new)
        importer.import
      end
    end
  end
end
