require 'open-uri'

class SharepointTradeArticleData
  include Importer
  include SharepointHelpers
  ENDPOINT = "#{Rails.root}/data/sharepoint_trade_articles/*"

  SINGLE_VALUE_XPATHS = {
    id:                       '//id',
    title:                    '//title',
    short_title:              '//short_title',
    summary:                  '//summary',
    creation_date:            '//creation_date',
    release_date:             '//release_date',
    expiration_date:          '//expiration_date',
    evergreen:                '//evergreen',
    content:                  '//content',
    keyword:                  '//keyword',
    seo_metadata_title:       '//seometadatatitle',
    seo_metadata_description: '//seometadatadescription',
    seo_metadata_keyword:     '//seometadatakeyword',
    trade_url:                '//trade_url',
  }.freeze

  MULTI_VALUE_XPATHS = {
    industries:        '//tags//industries//industry',
    countries:         '//tags//countries//country',
    trade_regions:     '//tags//trade_regions//trade_region',
    trade_programs:    '//tags//trade_programs//trade_programs',
    trade_initiatives: '//tags//trade_initiatives//trade_initiatives',
    export_phases:     '//tags//export_phases//export_phase',
    url_html_source:   '//data//html',
    url_xml_source:    '//data//xml',
  }.freeze

  EMPTY_KEYS = {
    source_agencies:       [],
    source_business_units: [],
    source_offices:        [],
    file_url:              [],
    image_url:             [],
    topics:                [],
    sub_topics:            [],
    geo_regions:           [],
    geo_subregions:        [],
  }.freeze

  def initialize(resource = ENDPOINT)
    @resources = Dir[resource]
  end

  def import
    Rails.logger.info "Importing #{@resource}"
    data = []

    @resources.each do |resource|
      article = Nokogiri::XML(open(resource))
      article = extract_article_fields(article)
      data << article
    end
    articles = data.map { |article_hash| process_article_info(article_hash) }.compact
    SharepointTradeArticle.index articles
  end

  private

  def extract_article_fields(article)
    article_info = article.xpath('//article')
    article_hash = extract_fields(article_info, SINGLE_VALUE_XPATHS)
    article_hash.merge! extract_multi_valued_fields(article_info, MULTI_VALUE_XPATHS)
    EMPTY_KEYS.each do |k, v|
      article_hash[k] = v.clone
    end
    article_hash = extract_source_agencies(article_info, article_hash)
    article_hash = extract_sub_elements(article_info, article_hash, :geo_regions, :geo_subregions, '//geo_region', '//geo_subregion')
    article_hash = extract_sub_elements(article_info, article_hash, :topics, :sub_topics, '//topic', '//sub_topic')
    article_hash = extract_src_text(article_info, article_hash, :file_url, '//files/file')
    article_hash = extract_src_text(article_info, article_hash, :image_url, '//images/image')
    article_hash
  end

  def process_article_info(article)
    article[:countries] = article[:countries].map { |country| lookup_country(country) }.compact
    article[:content] &&= Sanitize.clean(article[:content])
    article[:creation_date] &&= Date.strptime(article[:creation_date], '%m/%d/%Y').to_s
    article[:release_date] &&= Date.strptime(article[:release_date], '%m/%d/%Y').to_s
    article[:expiration_date] &&= Date.strptime(article[:expiration_date], '%m/%d/%Y').to_s
    article = remove_duplicates(article)
    article = replace_nulls(article)
    article
  end
end
