require 'spec_helper'

describe TradeLead do
  let(:importers)     do
    [TradeLead::FbopenImporter::FullData,
     TradeLead::AustraliaData,
     TradeLead::CanadaData,
     TradeLead::StateData,
     TradeLead::UkData,
     TradeLead::McaData,
     TradeLead::UstdaData]
  end

  describe '#importers' do
    it 'returns correct importers' do
      expect(described_class.importers).to match(importers)
    end
  end
end
