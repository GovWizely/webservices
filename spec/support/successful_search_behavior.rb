shared_examples 'a successful search request' do
  describe '#status' do
    subject { super().status }
    it { is_expected.to eq(200) }
  end

  describe '#content_type' do
    subject { super().content_type }
    it { is_expected.to eq(:json) }
  end
end
