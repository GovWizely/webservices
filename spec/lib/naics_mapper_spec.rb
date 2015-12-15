require 'spec_helper'

describe NaicsMapper do
  describe '#lookup_naics_code' do
    mapper = NaicsMapper.new
    it 'returns a title for a 2012 code' do
      expect(mapper.lookup_naics_code('111110')).to eq('Soybean Farming')
    end

    it 'returns a title for a 2007 code when not found in 2012' do
      expect(mapper.lookup_naics_code('311712')).to eq('Fresh and Frozen Seafood Processing')
    end

    it 'raises an exception if a code is not found' do
      expect { mapper.lookup_naics_code('1337') }.to raise_error('NAICS code not found: 1337')
    end
  end
end
