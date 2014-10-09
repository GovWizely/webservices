shared_examples 'a paginated query' do
  context 'when offset/size not specified' do
    subject { described_class.new({}) }

    its(:offset) { should == 0 }
    its(:size) { should == 10 }
  end

  context 'when options include offset and size' do
    subject { described_class.new(offset: '30', size: '8') }

    its(:offset) { should == 30 }
    its(:size) { should == 8 }
  end
end

shared_examples 'a relevance-sorted query' do
  context 'when q is specified' do
    subject { described_class.new(q: 'cat products') }

    its(:sort) { should == nil }
  end

  context 'when q is not specified' do
    subject { described_class.new({}) }

    its(:sort) { should_not == nil }
  end
end
