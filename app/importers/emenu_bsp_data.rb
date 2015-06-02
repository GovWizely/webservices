require 'open-uri'

class EmenuBspData
  include Importer
  ENDPOINT = 'http://emenuapps.ita.doc.gov/ePublic/bsp/alljson/en/bsp.xml'

  COLUMN_HASH = {
    'cs-contact'  => :ita_contact_email,
    'name'        => :company_name,
    'phone'       => :company_phone,
    'address'     => :company_address,
    'website'     => :company_website,
    'description' => :company_description,
    'email'       => :company_email,
  }.freeze

  def initialize(resource = ENDPOINT)
    @resource = resource
  end

  def import
    doc = JSON.parse(open(@resource, 'r:UTF-8').read)
    articles = doc['bsps']['bsp'].map { |article_hash| process_article_info article_hash }
    EmenuBsp.index articles
  end

  private

  def process_article_info(article_hash)
    article = remap_keys COLUMN_HASH, article_hash['company']
    article[:ita_office] = article_hash['site']
    article[:contact_title] = article_hash['company']['contact']['title']
    article[:contact_name] = article_hash['company']['contact']['name']
    article[:category] =  article_hash['company']['category']['title']
    article[:id] = Utils.generate_id(article, %i(company_name company_description))
    sanitize_entry(article)
  end
end
