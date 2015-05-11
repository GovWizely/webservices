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
end
