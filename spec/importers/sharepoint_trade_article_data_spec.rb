require 'spec_helper'

describe SharepointTradeArticleData do
  fixtures_dir = "#{File.dirname(__FILE__)}/sharepoint_trade_article"
  fixtures_files = (116..119).map { |id| open("#{Rails.root}/spec/fixtures/sharepoint_trade_articles/articles/#{id}.xml").read }

  s3 = stubbed_s3_client('sharepoint_trade_article')
  s3.stub_responses(:list_objects, contents: [{ key: '116.xml' }, { key: '117.xml' }, { key: '118.xml' }, { key: '119.xml' }])
  s3.stub_responses(:get_object, { body: fixtures_files[0] }, { body: fixtures_files[1] }, { body: fixtures_files[2] }, body: fixtures_files[3])

  let(:importer) { SharepointTradeArticleData.new(s3) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/results.yaml") }

  it_behaves_like 'an importer which indexes the correct documents'
end
