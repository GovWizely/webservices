require 'open-uri'

class ItaZipCodeData
  include Importer
  POST_URL = 'http://emenuapps.ita.doc.gov/ePublic/GetPost?type=odo'
  ZIP_CODE_URL = 'http://emenuapps.ita.doc.gov/ePublic/GetPost?ZipCode=all'

  POST_SINGLE_VALUED_XPATHS = {
    post:              './POST',
    office_name:       './OFFICENAME',
    country:           './COUNTRYID',
    state:             './STATE',
    email:             './EMAIL',
    fax:               './FAX',
    mail_instructions: './MAIL_INSTR',
    phone:             './PHONE',
  }.freeze

  POST_MULTI_VALUED_XPATHS = {
    address: './ADDRESS',
  }

  ZIP_XPATHS = {
    zip_code: './ZIPCODE',
    post:     './POST',
    zip_city: './CITY',
    state:    './STATE',
  }

  def initialize(post_resource = POST_URL, zip_code_resource = ZIP_CODE_URL)
    @post_resource = post_resource
    @zip_code_resource = zip_code_resource
  end

  def import
    post_doc = Nokogiri::XML(open(@post_resource))
    ita_office_locations = post_doc.xpath('//POSTINFO').map { |location_info| process_location_info(location_info) }

    zip_code_doc = Nokogiri::XML(open(@zip_code_resource))
    zip_entries = zip_code_doc.xpath('//ZIPINFO').map { |zip_info| process_zip_info(zip_info) }

    ItaZipCode.index combine_hashes(zip_entries, ita_office_locations)
  end

  private

  def combine_hashes(zip_entries, ita_office_locations)
    combined_hashes = []
    zip_entries.each do |zip_entry|
      ita_office_locations.each do |office|
        if zip_entry[:post] == office[:post]
          combined_hashes.push zip_entry.merge(office)
        end
      end
    end
    combined_hashes
  end

  def process_zip_info(zip_info)
    zip_hash = extract_fields(zip_info, ZIP_XPATHS)
    zip_hash
  end

  def process_location_info(location_info)
    event_hash = extract_fields(location_info, POST_SINGLE_VALUED_XPATHS)
    event_hash.reverse_merge! extract_multi_valued_fields(location_info, POST_MULTI_VALUED_XPATHS)
    event_hash[:country] = lookup_country_by_id(event_hash[:country])
    assign_city(event_hash)
    event_hash[:state] = event_hash[:state].present? ? lookup_state(event_hash[:state]) : nil
    event_hash
  end

  def lookup_country_by_id(country_id)
    IsoCountryCodes.find(country_id).alpha2
  end

  def assign_city(event_hash)
    event_hash[:post_city] = parse_city_from_address(event_hash)
  end
end
