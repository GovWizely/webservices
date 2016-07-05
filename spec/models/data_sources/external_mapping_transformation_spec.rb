require 'spec_helper'
describe DataSources::ExternalMappingTransformation do
  describe 'caching' do
    let(:emt) do
      DataSources::ExternalMappingTransformation.new(urls: [{ url: 'some url', result_path: 'some path' }],
                                                     ttl:  '1 year',)
    end

    it 'sets the correct expiry in seconds' do
      expect(Rails.cache).to receive(:fetch).with('some url', expires_in: 31_557_600)
      emt.transform('foo')
    end

    it 'sets the correct expiry as a Fixnum not a Float' do
      expect(Rails.cache).to receive(:fetch).with('some url', expires_in: an_instance_of(Fixnum))
      emt.transform('foo')
    end
  end
end
