require 'spec_helper'

describe 'Trade Articles API V1' do
  before(:all) do
    TradeArticle.recreate_index
    fixtures_file = "#{Rails.root}/spec/fixtures/trade_articles/trade_articles.json"
    TradeArticleData.new(fixtures_file).import
  end

  let(:v1_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v1' } }
  let(:expected_results) { JSON.parse open("#{Rails.root}/spec/fixtures/trade_articles/results.json").read }

  describe 'GET /trade_articles/search.json' do
    let(:params) { { q: 'multilateral development team',
                     evergreen: 'false',
                     pub_date_start: '2013-05-14',
                     pub_date_end: '2013-05-15',
                     update_date_start: '2013-06-12',
                     update_date_end: '2013-06-12' } }

    context 'when all params are specified' do
      before { get '/trade_articles/search', params, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns matching trade articles' do
        json_response = JSON.parse(response.body)
        json_response['total'].should == 1

        results = json_response['results']
        results[0].should == expected_results[0]
      end
    end

  end
end
