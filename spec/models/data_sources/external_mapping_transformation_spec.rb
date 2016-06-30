require 'spec_helper'
describe DataSources::ExternalMappingTransformation do
  describe 'caching' do
    let(:emt) do
      DataSources::ExternalMappingTransformation.new(urls: [{ url: 'some url', result_path: 'some path' }],
                                                     ttl:  '4 hours',)
    end

    it 'sets the correct expiry in seconds' do
      expect(Rails.cache).to receive(:fetch).with('some url', expires_in: 14_400)
      emt.transform('foo')
    end
  end
end
