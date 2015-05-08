require 'spec_helper'

describe Importers do
  let(:importers) do
    [TradeEvent::DlData, TradeEvent::EximData, TradeEvent::ItaData,
     TradeEvent::SbaData, TradeEvent::UstdaData]
  end

  context 'with the TradeEvent module' do
    it 'returns the correct importers' do
      expect(TradeEvent.importers).to match_array(importers)
    end
  end
end
