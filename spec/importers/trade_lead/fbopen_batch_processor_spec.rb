require 'spec_helper'

BatchProcessor = TradeLead::FbopenImporter::BatchProcessor
describe 'BatchProcessor' do
  describe '#process!' do
    it 'should execute when reaching batch size' do
      pentries = []
      b = BatchProcessor.new(2) { |x| pentries = x }
      b.queued_process(1)
      b.queued_process(1)
      expect(pentries).to be_eql [1,1]
    end
    it 'should not execute before reaching batch size' do
      pentries = []
      b = BatchProcessor.new(2) { |x| pentries = x }
      b.queued_process(1)
      expect(pentries).to be_empty
    end
  end
end
