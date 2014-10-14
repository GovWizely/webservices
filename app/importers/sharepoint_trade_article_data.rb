require 'open-uri'
require 'pp'

class SharepointTradeArticleData
  include Importer
  ENDPOINT = '/Users/tmh/Desktop/articles/%d.xml'

  XPATHS = {
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
    industries:               '//tags//industries',
    countries:                '//tags//countries',
    trade_regions:            '//tags//trade_regions',
    trade_programs:           '//tags//trade_programs',
    trade_initiatives:        '//tags//trade_initiatives',
    export_phases:            '//tags//export_phases',
    seo_metadata_title:       '//seometadatatitle',
    seo_metadata_description: '//seometadatadescription',
    seo_metadata_keyword:     '//seometadatakeyword',
    trade_url:                '//trade_url',
    file_url:                 '//files',
    image_url:                '//images',
    url_html_source:          '//data//html',
    url_xml_source:           '//data//xml',
  }.freeze

  def initialize(resource = ENDPOINT)
    @resource = resource
  end

  def import
    Rails.logger.info "Importing #{@resource}"
    id = 116
    data = []

    while id <= 221
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
    article_hash = extract_fields(article_info, XPATHS)
    article_hash = extract_source_agencies(article_info, article_hash)
    article_hash
  end

  def extract_source_agencies(article_info, article_hash)
    article_hash[:source_agencies] = []

    article_info.xpath('//source_agencies/source_agency').each do |source_agency|
      source_business_units = []

      source_agency.xpath('source_business_unit').each do |source_business_unit|
        source_business_units << source_business_unit.text
      end
      source_agency.search('.//source_business_unit').remove

      source_agency_hash = { source_agency: source_agency.text, source_business_units: source_business_units }
      article_hash[:source_agencies] << source_agency_hash
    end
    article_hash
  end

  def process_article_info(article)
    process_countries(article)

    article[:content] &&= Sanitize.clean(article[:content])
    article[:creation_date] &&= Date.strptime(article[:creation_date], '%m/%d/%Y').to_s
    article[:release_date] &&= Date.strptime(article[:release_date], '%m/%d/%Y').to_s
    article[:expiration_date] &&= Date.strptime(article[:expiration_date], '%m/%d/%Y').to_s
    article
  end

  def process_countries(article)
    if article[:countries].class == Array
      article[:countries].map { |country| lookup_country(country) }.compact 
    elsif article[:countries].class == String
      article[:countries] = lookup_country(article[:countries])
    end
  end

end
