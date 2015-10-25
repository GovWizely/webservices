require 'spec_helper'

describe Array do
  describe '#uniq_push!' do
    context 'insert new item' do
      before { array.uniq_push!(4) }
      let(:array) do
        [1, 2, 3]
      end
      it { expect(array).to eq([1, 2, 3, 4]) }
    end

    context 'preserve uniqueness' do
      before { array.uniq_push!(3) }
      let(:array) do
        [1, 2, 3]
      end
      it { expect(array).to eq([1, 2, 3]) }
    end
  end
end
