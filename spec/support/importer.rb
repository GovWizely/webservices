shared_examples 'an importer which can purge old documents' do
  subject { importer.can_purge_old? }
  it { is_expected.to be_truthy }
end

shared_examples 'an importer which cannot purge old documents' do
  subject { importer.can_purge_old? }
  it { is_expected.to be_falsey }
end

shared_examples 'an importer which indexes the correct documents' do
  it 'indexes the correct documents' do
    expect(importer.model_class).to receive(:index) do |indexed_docs|
      expect(indexed_docs).to match_array(expected)
    end
    importer.model_class.recreate_index
    importer.import
  end
end
