require 'spec_helper'

describe String do
  describe '#indexize' do
    subject { operand.indexize }
    context 'of "TradeEvent::Ita"' do
      let(:operand) { 'TradeEvent::Ita' }
      it { is_expected.to eq 'trade_event:itas' }
    end

    context 'of "TradeEvent::Sba"' do
      let(:operand) { 'TradeEvent::Sba' }
      it { is_expected.to eq 'trade_event:sbas' }
    end

    context 'of "TradeEvent::Exim"' do
      let(:operand) { 'TradeEvent::Exim' }
      it { is_expected.to eq 'trade_event:exims' }
    end

    context 'of "BisDeniedPerson"' do
      let(:operand) { 'BisDeniedPerson' }
      it { is_expected.to eq 'bis_denied_people' }
    end

    context 'of "AustralianFooBar"' do
      let(:operand) { 'AustralianFooBar' }
      it { is_expected.to eq 'australian_foo_bars' }
    end
  end

  describe '#typeize' do
    subject { operand.typeize }
    context 'of "TradeEvent::Ita"' do
      let(:operand) { 'TradeEvent::Ita' }
      it { is_expected.to eq :'trade_event:ita' }
    end

    context 'of "TradeEvent::Sba"' do
      let(:operand) { 'TradeEvent::Sba' }
      it { is_expected.to eq :'trade_event:sba' }
    end

    context 'of "TradeEvent::Exim"' do
      let(:operand) { 'TradeEvent::Exim' }
      it { is_expected.to eq :'trade_event:exim' }
    end

    context 'of "BisDeniedPerson"' do
      let(:operand) { 'BisDeniedPerson' }
      it { is_expected.to eq :bis_denied_person }
    end

    context 'of "AustralianTradeLead"' do
      let(:operand) { 'AustralianTradeLead' }
      it { is_expected.to eq :australian_trade_lead }
    end
  end
end
