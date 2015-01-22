require 'spec_helper'

describe Hash do
  describe '#deep_stringify' do
    subject { operand.deep_stringify }
    context 'of a simple Hash' do
      let(:operand) do
        { :one => :two, :three => 'four', 'five' => :six, 1 => nil }
      end
      it { is_expected.to eq('1' => nil, 'five' => 'six', 'one' => 'two', 'three' => 'four') }
    end

    context 'of a nested Hash' do
      let(:operand) do
        { one: { two: { three: false } } }
      end
      it { is_expected.to eq('one' => { 'two' => { 'three' => false } }) }
    end

    context 'of a Hash that might confuse the internal implementation' do
      let(:operand) do
        { one: 'null' }
      end
      it { is_expected.to eq('one' => 'null') }
    end
  end
end
