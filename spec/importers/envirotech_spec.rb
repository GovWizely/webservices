require 'spec_helper'

describe Envirotech do
  describe '.import_all_sources' do
    let(:all_issue_info) { { dummy: 1 } }
    let(:local_data) { { 'dummy' => 1 } }

    before do
      allow_any_instance_of(Envirotech::IssueData).to receive(:fetch_data).and_return({})
      allow_any_instance_of(Envirotech::BackgroundLinkData).to receive(:fetch_data).and_return({})
      allow_any_instance_of(Envirotech::AnalysisLinkData).to receive(:fetch_data).and_return({})
      allow_any_instance_of(Envirotech::ProviderData).to receive(:fetch_data).and_return({})
      allow_any_instance_of(Envirotech::ProviderSolutionData).to receive(:fetch_data).and_return({})
      allow_any_instance_of(Envirotech::RegulationData).to receive(:fetch_data).and_return({})
      allow_any_instance_of(Envirotech::SolutionData).to receive(:fetch_data).and_return({})

      scraper = double('Envirotech::ToolkitScraper')
      allow(Envirotech::ToolkitScraper).to receive(:new).and_return(scraper)
      allow(scraper).to receive(:all_issue_info).and_return(all_issue_info)
      allow(JSON).to receive(:parse).and_return(local_data)

      allow(Envirotech::Login).to receive(:headless_login)
    end

    it 'start importers sequentially' do
      expect_any_instance_of(Envirotech::IssueData).to receive(:fetch_data)
      expect_any_instance_of(Envirotech::BackgroundLinkData).to receive(:fetch_data)
      expect_any_instance_of(Envirotech::AnalysisLinkData).to receive(:fetch_data)
      expect_any_instance_of(Envirotech::ProviderData).to receive(:fetch_data)
      expect_any_instance_of(Envirotech::RegulationData).to receive(:fetch_data)
      expect_any_instance_of(Envirotech::SolutionData).to receive(:fetch_data)
      expect_any_instance_of(Envirotech::ProviderSolutionData).to receive(:fetch_data)
      expect(Envirotech::ToolkitData).to receive(:fetch_relational_data)

      described_class.import_all_sources
    end
  end
end
