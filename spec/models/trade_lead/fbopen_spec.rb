require 'spec_helper'

describe TradeLead::Fbopen, type: :model do
  describe '#self.importer_class' do

    it 'returns correct importer_class' do
      expect(described_class.importer_class).to match(TradeLead::FbopenImporter::FullData)
    end

  end
end
