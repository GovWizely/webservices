require 'csv'

module TradeLead
  class UkData
    include Importable
    include VersionableResource
    CONTAINS_MAPPER_LOOKUPS = true

    def initialize(resource = nil)
      @resource = resource
    end

    def import
      xml_body = loaded_resource

      # The source XML file states that its content in encoded in utf-16, but
      # it appears to actually be encoded in utf-8. Go figure. Despite telling
      # Nokogiri to treat the document as utf-8, I continued to get errors
      # related to it thinking that the document was encoded in utf-16. A more
      # direct way to make Nokogiri think the docuemnt is utf-8 is to edit
      # the actual content as I do here.
      xml_body['encoding="utf-16"'] = 'encoding="utf-8"'

      leads = Nokogiri::XML(xml_body).xpath('//FullNotice').map do |info|
        process_lead_info(info)
      end.compact

      model_class.index(leads)
    end

    def loaded_resource
      @resource ? File.open(@resource).read : fetch_xml.body
    end

    private

    # :nocov:
    def fetch_xml
      base = 'https://www.contractsfinder.service.gov.uk'
      agent = Mechanize.new
      # You have to view the results you wish to download first before initiating the CSV download
      agent.get("#{base}/Search/Results",         IncludeClosed:  'False',
                                                  IncludeAwarded: 'False',
                                                  LocationType:   'AllLocations',
                                                  sort:           'PublicationDescending')
      agent.get("#{base}/Search/GetXmlFile")
    end
    # :nocov:

    XPATHS = {
      id:                       './Id',
      reference_number:         './Notice/Identifier',
      publish_date:             './Notice/PublishedDate',
      min_contract_value:       './Notice/ValueLow',
      max_contract_value:       './Notice/ValueHigh',
      status:                   './Notice/Status',
      url:                      './Notice/ContactDetails/WebAddress',
      procurement_organization: './Notice/OrganisationName',
      contact:                  './Notice/ContactDetails/Email',
      title:                    './Notice/Title',
      description:              './Notice/Description',
      notice_type:              './Notice/Type',
      specific_location:        './Notice/Region',
      industry:                 './Notice/Sector',
    }

    def process_lead_info(lead_info)
      lead = extract_fields(lead_info, XPATHS)

      if %w(closed awarded).include?(lead[:status].downcase)
        fail "Should not be any docs with status #{lead[:status]}"
      end

      lead = process_additional_fields(lead)
      lead[:url] = UrlMapper.get_bitly_url(lead[:url], model_class) if lead[:url].present?
      sanitize_entry(lead)
    end

    def process_additional_fields(lead)
      lead[:publish_date] = lead[:publish_date] ? parse_date(lead[:publish_date]) : nil
      lead[:source] = model_class.source[:code]
      lead[:country] = 'GB'
      lead.merge! add_geo_fields([lead[:country]])
      process_industries(lead)
      lead
    end

    def process_industries(lead)
      lead[:industry] = split_industries(lead[:industry]) if lead[:industry]
      lead[:ita_industries] = lead[:industry] ? get_mapper_terms_from_array(lead[:industry]) : []
    end

    def split_industries(industry)
      industry.split(',').map(&:squish)
    end
  end
end
