require 'open-uri'

class TradeArticleData
  include Importer
  ENDPOINT = 'https://new.export.gov/community/posts/content.json'

  COLUMN_HASH = {
    id:                 :id,
    core:               :evergreen,
    post:               :content,
    published_at:       :pub_date,
    updated_at:         :update_date,
    title:              :title,
    content_type_tags:  :content_type,
    export_phase_tags:  :export_phase,
    industry_tags:      :industry,
    topic_tags:         :topic,
    subtopic_tags:      :subtopic,
    trade_region_tags:  :trade_region,
    geo_region_tags:    :geo_region,
    geo_subregion_tags: :geo_subregion,
    country_tags:       :country,
    keyword_tags:       :keyword,
  }.freeze

  def initialize(resource = ENDPOINT)
    @resource = resource
  end

  def import
    Rails.logger.info "Importing #{@resource}"
    doc = JSON.parse(open(@resource).read, symbolize_names: true)
    articles = doc.map { |article_hash| process_article_info article_hash }
    TradeArticle.index articles
  end

  private

  def process_article_info(article_hash)
    article = remap_keys COLUMN_HASH, article_hash
    article[:content] = Sanitize.clean(article[:content]) if article[:content]
    article[:title] = CGI.unescapeHTML(article[:title]) if article[:title]
    article[:pub_date] = Date.parse(article[:pub_date]) if article[:pub_date]
    article[:update_date] = Date.parse(article[:update_date]) if article[:update_date]
    article
  end
end
