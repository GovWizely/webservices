require 'spec_helper'

describe String do
  describe '#indexize' do
    subject { operand.indexize }
    context 'of "FooBar::Ita"' do
      let(:operand) { 'FooBar::Ita' }
      it { is_expected.to eq 'foo_bar:itas' }
    end

    context 'of "FooBar::Sba"' do
      let(:operand) { 'FooBar::Sba' }
      it { is_expected.to eq 'foo_bar:sbas' }
    end

    context 'of "FooBar::Exim"' do
      let(:operand) { 'FooBar::Exim' }
      it { is_expected.to eq 'foo_bar:exims' }
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
    context 'of "FooBar::Ita"' do
      let(:operand) { 'FooBar::Ita' }
      it { is_expected.to eq :'foo_bar:ita' }
    end

    context 'of "FooBar::Sba"' do
      let(:operand) { 'FooBar::Sba' }
      it { is_expected.to eq :'foo_bar:sba' }
    end

    context 'of "FooBar::Exim"' do
      let(:operand) { 'FooBar::Exim' }
      it { is_expected.to eq :'foo_bar:exim' }
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
