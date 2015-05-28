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

  CATEGORIES = [
    'Accounting, Auditing and Tax Services',
    'Advertising',
    'Architecture, Interior Design and Furniture',
    'Banking and Financial Services',
    'Building and Construction Services',
    'Business Administration Services',
    'Business Associations',
    'Business Consulting',
    'Business Development',
    'Car Services and Rentals',
    'Chambers of Commerce',
    'Computer and Internet Services',
    'Customs Brokerage',
    'Debt Collection',
    'Distributors, Sales Agents and Importers',
    'Education and Training Services',
    'Electronic Components and Supplies',
    'Engineering Services',
    'Entertainment Services',
    'Environmental Services',
    'Event Management, Conference Equipment and Facilitation',
    'Export Management',
    'Graphic Design',
    'Hospitals, Clinics and Health Services',
    'Hotels and Meeting Facilities',
    'Human Resources',
    'Insurance Services',
    'Legal Services',
    'Manufacturing and Industrial Production Services',
    'Market Research',
    'Marketing, Public Relations and Sales',
    'Mining and Oil and Gas Services',
    'Office Furniture',
    'Office Rental',
    'Other Business Services',
    'Patent and Trademark Law Services',
    'Photographic Services',
    'Printing and Publishing Services',
    'Product Standards, Testing, and Certification',
    'Real Estate Services',
    'Regional Economic Development',
    'Relocation services',
    'Restaurants and Catering',
    'Retailers',
    'Security and Personal Safety',
    'Telecommunications',
    'Trade Show and Exhibition Services',
    'Translation and Interpretation',
    'Transportation, Freight Forwarder and Storage Services',
    'Travel Facilitation',
    'Vetting/Due Diligence',
  ].freeze

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
    category = article_hash['company']['category']['title']
    article[:category] = CATEGORIES.include?(category) ? category : nil
    article
  end
end
