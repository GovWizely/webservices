require 'spec_helper'

BatchProcessor = TradeLead::FbopenImporter::BatchProcessor
describe 'BatchProcessor' do
  describe '#process!' do
    it 'should not execute before reaching batch size' do
      pentries = []
      b = BatchProcessor.new(2) { |x| pentries = x }
      b.batched_process(1)
      expect(pentries).to be_empty
    end
    it 'should execute when reaching batch size' do
      pentries = []
      b = BatchProcessor.new(2) { |x| pentries = x }
      b.batched_process(1)
      b.batched_process(1)
      expect(pentries).to eq([1, 1])
    end
    it 'should process each batch independently' do
      pentries = []
      b = BatchProcessor.new(2) { |x| pentries = x }
      b.batched_process(1)
      b.batched_process(2)
      b.batched_process(3)
      b.batched_process(4)
      expect(pentries).to eq([3, 4])
    end
  end
end
