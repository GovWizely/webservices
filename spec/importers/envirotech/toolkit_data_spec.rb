require 'spec_helper'

describe Envirotech::ToolkitData do
  subject { described_class.fetch_relational_data }

  before do
    scraper = double('Envirotech::ToolkitScraper')
    allow(Envirotech::ToolkitScraper).to receive(:new).and_return(scraper)
    allow(scraper).to receive(:all_issue_info).and_return(all_issue_info)
    allow(JSON).to receive(:parse).and_return(local_data)
  end

  describe '#import' do
    context 'scraper working as expected' do
      let(:all_issue_info) { { dummy: 1 } }
      let(:local_data) { { 'dummy' => 1 } }
      it 'get relation_data' do
        subject
      end
    end

    context 'scraper compairing local data with imported data' do
      let(:all_issue_info) { { dummy: 1 } }
      let(:local_data) { { 'dummy' => 2 } }
      it 'notify Airbrake when data mismatch' do
        expect(Airbrake).to receive(:notify).with(Exceptions::EnvirotechToolkitDataMismatch.new)
        subject
      end
    end

    context 'scraper fallback to local data' do
      let(:all_issue_info) { {} }
      let(:local_data) { { 'dummy' => 2 } }
      it 'notify Airbrake when UI tool disappear' do
        expect(Airbrake).to receive(:notify).with(Exceptions::EnvirotechToolkitNotFound.new)
        subject
      end
    end
  end
end
