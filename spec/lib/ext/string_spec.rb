require 'spec_helper'

describe String do
  describe '#indexize' do
    subject { operand.indexize }
    context 'of "TradeEvent::Ita"' do
      let(:operand) { 'TradeEvent::Ita' }
      it { should eq 'trade_event:itas' }
    end

    context 'of "TradeEvent::Sba"' do
      let(:operand) { 'TradeEvent::Sba' }
      it { should eq 'trade_event:sbas' }
    end

    context 'of "BisDeniedPerson"' do
      let(:operand) { 'BisDeniedPerson' }
      it { should eq 'bis_denied_people' }
    end

    context 'of "AustralianTradeLead"' do
      let(:operand) { 'AustralianTradeLead' }
      it { should eq 'australian_trade_leads' }
    end
  end

  describe '#typeize' do
    subject { operand.typeize }
    context 'of "TradeEvent::Ita"' do
      let(:operand) { 'TradeEvent::Ita' }
      it { should eq 'trade_event:ita' }
    end

    context 'of "TradeEvent::Sba"' do
      let(:operand) { 'TradeEvent::Sba' }
      it { should eq 'trade_event:sba' }
    end

    context 'of "BisDeniedPerson"' do
      let(:operand) { 'BisDeniedPerson' }
      it { should eq 'bis_denied_person' }
    end

    context 'of "AustralianTradeLead"' do
      let(:operand) { 'AustralianTradeLead' }
      it { should eq 'australian_trade_lead' }
    end
  end
end
