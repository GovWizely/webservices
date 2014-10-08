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
