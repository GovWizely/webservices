require 'spec_helper'

describe Envirotech::ImportWorker do
  it 'calls Envirotech.import_sequentially' do
    expect(Envirotech).to receive(:import_sequentially)
    described_class.new.perform
  end
end
