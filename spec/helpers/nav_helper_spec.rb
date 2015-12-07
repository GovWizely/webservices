require 'spec_helper'

describe NavHelper do
  describe '#top_apis' do
    subject { helper.top_apis }
    it { is_expected.to be_a Hash }
  end

  describe '#api_resources' do
    subject { helper.api_resources }
    it { is_expected.to be_a Hash }
  end

  describe '#additional_resources' do
    subject { helper.additional_resources }
    it { is_expected.to be_a Hash }
  end
end
