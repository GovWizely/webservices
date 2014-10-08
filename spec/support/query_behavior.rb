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
