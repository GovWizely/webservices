shared_examples 'an importer which can purge old documents' do
  subject { described_class.new.can_purge_old? }
  it { is_expected.to be_truthy }
end

shared_examples 'an importer which cannot purge old documents' do
  subject { described_class.new.can_purge_old? }
  it { is_expected.to be_falsey }
end
