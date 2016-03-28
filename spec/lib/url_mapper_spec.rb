require 'spec_helper'

describe UrlMapper do
  let(:now) { Time.now.utc }

  before do
    UrlMapper.recreate_index
    UrlMapper.index([{ id:          Digest::SHA1.hexdigest('http://www.google.com'),
                       link:        'http://bit.ly/randomid',
                       long_url:    'http://www.google.com',
                       title:       'Title',
                       _updated_at: now, },],)
  end

  describe '#get_bitly_url' do
    let(:long_url) { 'http://www.google.com' }
    let(:bitly_url) { 'http://bit.ly/randomid' }
    let(:title) { 'Title' }
    let(:model_class) { Object }
    before(:each) do
      Rails.application.config.enable_bitly_lookup = enable_bitly_lookup
    end
    after(:each) do
      Rails.application.config.enable_bitly_lookup = true
    end

    context 'when config.enable_bitly_lookup is true' do
      let(:enable_bitly_lookup) { true }
      it 'return a shortened url' do
        expect(UrlMapper).to receive(:process_url).once.and_return(bitly_url)
        expect(UrlMapper.get_bitly_url(long_url, model_class)).to eq(bitly_url)
      end
    end

    context 'when config.enable_bitly_lookup is false' do
      let(:enable_bitly_lookup) { false }
      before(:each) do
        @actual = UrlMapper.get_bitly_url(long_url, model_class)
      end

      context 'when protocol is missing from the url' do
        let(:long_url) { 'www.google.com' }
        it 'return the original url with "http" prepended' do
          expect(@actual).to eq("http://#{long_url}")
        end
      end

      context 'when protocol is specified in the url' do
        it 'return the original url' do
          expect(@actual).to eq(long_url)
        end
      end
    end
  end

  describe '#search_for_url' do
    it 'returns the correct search result' do
      expected = { total: 1, max_score: 1.0, hits: [{ _index:  'test:webservices:url_mappers',
                                                      _type:   'url_mapper',
                                                      _id:     '738ddf35b3a85a7a6ba7b232bd3d5f1e4d284ad1',
                                                      _score:  1.0,
                                                      _source: { link: 'http://bit.ly/randomid', long_url: 'http://www.google.com', title: 'Title', _updated_at: now.strftime('%FT%TZ') }, },], }
      expect(UrlMapper.search_for_url('http://www.google.com')).to eq(expected)
    end
  end

  describe '#call_bitly_api' do
    context 'When URI is invalid' do
      it 'Returns the original URL string' do
        allow(UrlMapper).to receive_message_chain(:open, :read) { '{"status_code": 500, "status_txt": "INVALID_URI"}' }
        expect(UrlMapper.call_bitly_api('request_string', 'url_string')).to eq('url_string')
      end
    end

    context 'When response from Bitly API is unexpected' do
      it 'Raises an exception' do
        bogus_response = '{"status_code": "1337"}'
        request_string = 'request_string'
        allow(UrlMapper).to receive_message_chain(:open, :read) { '{"status_code": "1337"}' }
        expect { UrlMapper.call_bitly_api(request_string, 'url_string') }.to raise_error(
          'Invalid Bitly API Response: ' + JSON.parse(bogus_response).to_s + '.  Request: ' + request_string,
        )
      end
    end
  end

  describe '#purge_old' do
    it 'purges documents that are older than two months' do
      UrlMapper.index([{ id:          Digest::SHA1.hexdigest('http://www.someurl.com'),
                         link:        'http://bit.ly/someid',
                         long_url:    'http://www.someurl.com',
                         title:       'Old Entry',
                         _updated_at: (Date.current - 65), },],)
      expect(UrlMapper.search_for_url('http://www.someurl.com')[:hits].count).to eq(1)
      UrlMapper.purge_old
      expect(UrlMapper.search_for_url('http://www.someurl.com')[:hits].count).to eq(0)
    end
  end

  describe '#process_url' do
    context 'When url is found locally and does not need update' do
      it 'returns the correct short link and updates anyways without calling Bitly' do
        expect(UrlMapper).to receive(:update) do |entries|
          expected = [{ id:       Digest::SHA1.hexdigest('http://www.google.com'),
                        link:     'http://bit.ly/randomid',
                        long_url: 'http://www.google.com',
                        title:    'Title', },]
          expect(entries).to match_array(expected)
        end
        expect(UrlMapper.process_url('http://www.google.com', 'Title')).to eq('http://bit.ly/randomid')
      end
    end

    context 'When url is found locally and needs update' do
      it 'returns the correct short link, updates the entry and calls Bitly' do
        allow(UrlMapper).to receive(:call_bitly_api) { 'http://bit.ly/randomid' }
        expect(UrlMapper.process_url('http://www.google.com', 'New Title')).to eq('http://bit.ly/randomid')
      end
    end

    context 'When url is not found locally' do
      it 'returns the correct short link, calls Bitly, and indexes the entry' do
        allow(UrlMapper).to receive(:call_bitly_api) { 'http://bit.ly/randomid2' }
        expect(UrlMapper).to receive(:index) do |entries|
          expected = [{ id:       Digest::SHA1.hexdigest('http://www.gewgle.com'),
                        link:     'http://bit.ly/randomid2',
                        long_url: 'http://www.gewgle.com',
                        title:    'Diff Title', },]
          expect(entries).to match_array(expected)
        end
        expect(UrlMapper.process_url('http://www.gewgle.com', 'Diff Title')).to eq('http://bit.ly/randomid2')
      end
    end

    context 'When there are multiple local entries for the same URL' do
      it 'raises an exception' do
        allow(UrlMapper).to receive(:search_for_url) { { hits: [{ result_1: 'result_1' }, { result_2: 'result_2' }] } }
        expect { UrlMapper.process_url('http://www.google.com', 'New Title') }.to raise_error('More than 1 search result, entries should be unique by long_url!')
      end
    end
  end
end
