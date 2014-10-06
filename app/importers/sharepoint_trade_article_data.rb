require 'open-uri'

class SharepointTradeArticleData
  include Importer
  ENDPOINT = '/Users/tmh/Desktop/articles/%d.xml'

  COLUMN_HASH = {
    tags: :ita_tags,
    seometadatatitle:  :seo_metadata_title,
    seometadatadescription: :seo_metadata_description,
    seometadatakeyword: :seo_metadata_keyword,
    files: :file_url,
    images: :image_url
  }.freeze

  def initialize(resource = ENDPOINT)
    @resource = resource
  end

  def import
    Rails.logger.info "Importing #{@resource}"
    id=116
    data = []

    while id <= 213 do
      if id == 195
        #id += 1
        #next
      end
      begin
        resource = @resource % id
        article = Hash.from_xml(open(resource))
        data << article
      rescue
        next
      ensure
        id += 1
      end
    end

    articles = data.map { |article_hash| process_article_info article_hash }.compact

    SharepointTradeArticle.index articles
  end

  private

  def process_article_info(article_hash)
    article_hash = article_hash["articles"]["article"].symbolize_keys
    article = Hash[article_hash.map {|k,v| [COLUMN_HASH[k] || k, v ] } ] 
    article[:ita_tags] = Hash[article[:ita_tags].map{|k,v| [k.to_sym, v ] } ]

    article[:data].symbolize_keys!
    article[:url_html_source] = article[:data][:html] 
    article[:url_xml_source] = article[:data][:xml]
    article.delete(:data)

    #article[:content] &&= Nokogiri::HTML.fragment(article[:content]).inner_text.squish
    article[:content] &&= Sanitize.clean(article[:content])

    article[:creation_date] &&= Date.strptime(article[:creation_date], "%m/%d/%Y").to_s
    article[:release_date] &&= Date.strptime(article[:release_date], "%m/%d/%Y").to_s
    article[:expiration_date] &&= Date.strptime(article[:expiration_date], "%m/%d/%Y").to_s
    article
  end

  def replace_null_field(value)
    if value == nil
      return ""
    else
      return value
    end
  end
end
