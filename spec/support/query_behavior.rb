shared_examples 'a paginated query' do
  context 'when offset/size not specified' do
    subject { described_class.new({}) }

    describe '#offset' do
      subject { super().offset }
      it { is_expected.to eq(0) }
    end

    describe '#size' do
      subject { super().size }
      it { is_expected.to eq(10) }
    end
  end

  context 'when options include offset and size' do
    subject { described_class.new(offset: '30', size: '8') }

    describe '#offset' do
      subject { super().offset }
      it { is_expected.to eq(30) }
    end

    describe '#size' do
      subject { super().size }
      it { is_expected.to eq(8) }
    end
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
