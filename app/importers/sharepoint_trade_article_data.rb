require 'open-uri'
require 'pp'

class SharepointTradeArticleData
  include Importer
  ENDPOINT = '/Users/tmh/Desktop/articles/%d.xml'

  SINGLE_XPATHS = {
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
    file_url:                 '//files',
    image_url:                '//images',
    url_html_source:          '//data//html',
    url_xml_source:           '//data//xml',
  }.freeze

  MULTIPLE_XPATHS = {
    industries:        '//tags//industries//industry',
    countries:         '//tags//countries//country',
    trade_regions:     '//tags//trade_regions//trade_region',
    trade_programs:    '//tags//trade_programs//trade_programs',
    trade_initiatives: '//tags//trade_initiatives//trade_initiatives',
    export_phases:     '//tags//export_phases//export_phase',
  }.freeze

  def initialize(resource = ENDPOINT)
    @resource = resource
  end

  def import
    Rails.logger.info "Importing #{@resource}"
    id = 116
    data = []

    while id <= 119
      begin
        resource = @resource % id
        article = Nokogiri::XML(open(resource))
        article = extract_article_fields(article)
        data << article
      rescue
        next
      ensure
        id += 1
      end
    end

    articles = data.map { |article_hash| process_article_info(article_hash) }.compact
    SharepointTradeArticle.index articles
  end

  private

  def extract_article_fields(article)
    article_info = article.xpath('//article')
    article_hash = extract_fields(article_info, SINGLE_XPATHS)
    article_hash.merge! extract_multi_valued_fields(article_info, MULTIPLE_XPATHS)
    article_hash = extract_source_agencies(article_info, article_hash)
    article_hash = extract_topics(article_info, article_hash)
    article_hash = extract_geo_regions(article_info, article_hash)
    article_hash
  end

  def extract_source_agencies(article_info, article_hash)
    article_hash[:source_agencies] = []

    article_info.xpath('//source_agencies/source_agency').each do |source_agency|
      source_business_units = []
      source_offices = extract_nodes(source_agency.xpath('//source_office'))

      source_agency.xpath('source_business_unit').each do |source_business_unit|
        source_business_units << source_business_unit.children.first.text
      end

      source_agency_hash = {
        source_agency:         source_agency.children.first.text,
        source_business_units: source_business_units,
        source_offices:        source_offices,
      }
      article_hash[:source_agencies] << source_agency_hash
    end
    article_hash
  end

  def extract_topics(article_info, article_hash)
    article_hash[:topics] = []

    article_info.xpath('//tags//topics//topic').each do |topic|
      sub_topics = extract_nodes(topic.xpath('//sub_topic'))
      topic_hash = { topic: topic.children.first.text, sub_topics: sub_topics }
      article_hash[:topics] << topic_hash
    end
    article_hash
  end

  def extract_geo_regions(article_info, article_hash)
    article_hash[:geo_regions] = []

    article_info.xpath('//tags//geo_regions//geo_region').each do |geo_region|
      geo_subregions = extract_nodes(geo_region.xpath('//geo_subregion'))
      geo_region_hash = { geo_region: geo_region.children.first.text, geo_subregions: geo_subregions }
      article_hash[:geo_regions] << geo_region_hash
    end
    article_hash
  end

  def process_article_info(article)
    article[:countries] = article[:countries].map { |country| lookup_country(country) }.compact
    article[:content] &&= Sanitize.clean(article[:content])
    article[:creation_date] &&= Date.strptime(article[:creation_date], '%m/%d/%Y').to_s
    article[:release_date] &&= Date.strptime(article[:release_date], '%m/%d/%Y').to_s
    article[:expiration_date] &&= Date.strptime(article[:expiration_date], '%m/%d/%Y').to_s
    article
  end
end
