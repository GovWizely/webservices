require 'spec_helper'

describe Searchable do
  describe '.COMMON_PARAMS' do
    subject { described_class::COMMON_PARAMS }
    it { is_expected.to eq(%i(api_key callback format offset size)) }
  end
end
