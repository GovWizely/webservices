shared_examples 'a paginated query' do
  context 'when offset/size not specified' do
    let(:query) { described_class.new }

    describe '#offset' do
      subject { query.offset }
      it { is_expected.to eq(0) }
    end

    describe '#size' do
      subject { query.size }
      it { is_expected.to eq(10) }
    end
  end

  context 'when options include offset and size' do
    let(:query) { described_class.new(offset: '30', size: '8') }

    describe '#offset' do
      subject { query.offset }
      it { is_expected.to eq(30) }
    end

    describe '#size' do
      subject { query.size }
      it { is_expected.to eq(8) }
    end
  end
end
