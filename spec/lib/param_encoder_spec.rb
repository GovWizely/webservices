require 'spec_helper'

describe ParamEncoder do
  describe 'handling spaces' do
    subject { ParamEncoder.encode('foo bar') }

    it { should eq('foo%20bar')}
  end

  describe 'handling special characters like ampersands commonly found in URLs' do
    subject { ParamEncoder.encode('http://www.foo.gov?x=1&y=2') }

    it { should eq('http%3A%2F%2Fwww.foo.gov%3Fx%3D1%26y%3D2')}
  end
end
