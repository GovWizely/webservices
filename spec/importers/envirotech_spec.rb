require 'spec_helper'

describe Envirotech do
  include_context 'empty Envirotech indices'

  describe '.import_sequentially' do
    let(:all_issue_info) do
      {
        _source: {
          version:       '',
          last_updated:  '',
          last_imported: '',
          import_rate:   '',
        },
      }
    end

    before do
      allow_any_instance_of(Envirotech::IssueData).to receive(:fetch_data).and_return({})
      allow_any_instance_of(Envirotech::BackgroundLinkData).to receive(:fetch_data).and_return({})
      allow_any_instance_of(Envirotech::AnalysisLinkData).to receive(:fetch_data).and_return({})
      allow_any_instance_of(Envirotech::ProviderData).to receive(:fetch_data).and_return({})
      allow_any_instance_of(Envirotech::ProviderSolutionData).to receive(:fetch_data).and_return({})
      allow_any_instance_of(Envirotech::RegulationData).to receive(:fetch_data).and_return({})
      allow_any_instance_of(Envirotech::SolutionData).to receive(:fetch_data).and_return({})
      allow_any_instance_of(Envirotech::RelationalData).to receive(:import).and_return({})
    end

    it 'start importers sequentially' do
      expect_any_instance_of(Envirotech::IssueData).to receive(:fetch_data)
      expect_any_instance_of(Envirotech::BackgroundLinkData).to receive(:fetch_data)
      expect_any_instance_of(Envirotech::AnalysisLinkData).to receive(:fetch_data)
      expect_any_instance_of(Envirotech::ProviderData).to receive(:fetch_data)
      expect_any_instance_of(Envirotech::RegulationData).to receive(:fetch_data)
      expect_any_instance_of(Envirotech::SolutionData).to receive(:fetch_data)
      expect_any_instance_of(Envirotech::ProviderSolutionData).to receive(:fetch_data)
      expect_any_instance_of(Envirotech::RelationalData).to receive(:import)

      described_class.import_sequentially
    end
  end

  describe '.import_all_sources' do
    subject { described_class.import_all_sources }
    it 'kicks off background import job' do
      expect(Envirotech::ImportWorker).to receive(:perform_async)
      subject
    end
  end
end
