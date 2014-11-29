require 'open-uri'

class SharepointTradeArticleData
  include Importer
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
    trade_url:             [],
  }.freeze

  def initialize(resource = ENDPOINT)
    @resource = resource
  end

  def import
    Rails.logger.info "Importing #{@resource}"

    articles = Dir[@resource].map do |resource|
      xml = Nokogiri::XML(open(resource))
      article_hash = extract_article_fields(xml)
      process_article_info(article_hash)
    end.compact

    SharepointTradeArticle.index(articles)
  end

  private

  def extract_article_fields(article)
    article_info = article.xpath('//article')
    article_hash = extract_fields(article_info, SINGLE_VALUE_XPATHS)
    article_hash.merge! extract_multi_valued_fields(article_info, MULTI_VALUE_XPATHS)
    EMPTY_KEYS.each { |k, v| article_hash[k] = v.clone }
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
    article[:trade_url] = 'http://www.export.gov/articles/' + article[:seo_metadata_title].parameterize + '.html'
    article[:industries] = normalize_industries( article[:industries] )
    article = remove_duplicates(article)
    article = replace_nulls(article)
    article
  end

  def extract_src_text(parent_node, hash, key, path)
    parent_node.xpath(path).each do |node|
      hash[key] << node.attribute('src').text
    end
    hash
  end

  def extract_source_agencies(parent_node, hash)
    parent_node.xpath('//source_agencies/source_agency').each do |source_agency|
      hash[:source_offices] += extract_nodes(source_agency.xpath('//source_office'))

      source_agency.xpath('source_business_unit').each do |source_business_unit|
        hash[:source_business_units] << source_business_unit.children.first.text
      end
      hash[:source_agencies] << source_agency.children.first.text
    end
    hash
  end

  def extract_sub_elements(parent_node, hash, parent_key, child_key, parent_path, child_path)
    parent_node.xpath(parent_path).each do |node|
      hash[child_key] += extract_nodes(node.xpath(child_path))
      hash[parent_key] << node.children.first.text
    end
    hash
  end

  def remove_duplicates(hash)
    hash.each do |_k, v|
      if v.class == Array
        v.uniq!
      end
    end
    hash
  end

  def replace_nulls(hash)
    hash.each do |k, v|
      if v.nil? && is_date?(k) == false
        hash[k] = ''
      end
    end
  end

  def is_date?(key)
    date_keys = [:creation_date, :release_date, :expiration_date]
    date_keys.include?(key)
  end
end
