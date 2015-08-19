shared_examples_for 'CanImportAllSources' do
  let(:namespace) { described_class }

  describe '.importers' do
    subject { described_class.importers }

    it 'is non-empty' do
      expect(subject.length).to be > 0
    end

    it 'only contains Importable classes' do
      offenders = subject.find_all { |i| i.class != Class || !i.include?(Importable) }
      expect(offenders.length).to eq(0)
    end

    it 'only contains enabled importers' do
      offenders = subject.find_all(&:disabled?)
      expect(offenders.length).to eq(0)
    end
  end

  describe '.import_all_sources' do
    subject { described_class.import_all_sources }

    it 'kicks off background import jobs for each importer' do
      described_class.importers.each do |i|
        expect(ImportWorker).to receive(:perform_async).with(i.name)
      end
      subject
    end
  end
end
