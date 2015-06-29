class TradeLead::FbopenImporter::BatchProcessor
  attr_accessor :batch_size, :block, :entries

  def initialize(batch_size = 1000, &block)
    self.batch_size = batch_size
    self.block = block
    self.entries = []
  end

  def batched_process(item)
    return unless item
    entries << item
    process! if should_process?
  end

  def should_process?
    entries.size >= batch_size
  end

  def process!
    block.call(entries)
    self.entries = []
  end
end
