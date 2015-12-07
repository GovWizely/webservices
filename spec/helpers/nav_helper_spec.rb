require 'spec_helper'

describe NavHelper do
  describe '#available_apis' do
    subject { helper.available_apis }
    it { is_expected.to be_a Hash }
  end

  describe '#additional_resources' do
    subject { helper.additional_resources }
    it { is_expected.to be_a Hash }
  end
end
