require 'spec_helper'

describe ImportWorker do
  before do
    class MockData
      def import
        true
      end
    end
  end

  after do
    Object.send(:remove_const, :MockData)
  end

  it "calls the Importer's import method" do
    expect_any_instance_of(MockData).to receive(:import)
    described_class.new.perform('MockData')
  end

  it 'only enqueues a given job once' do
    expect(described_class.get_sidekiq_options['unique']).to eq(:until_executed)
  end
end
