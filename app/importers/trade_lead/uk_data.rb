require 'csv'

module TradeLead
  class UkData
    include Importer

    def initialize(resource = nil)
      @resource = resource
    end

    def import
      xml_body = @resource ? File.open(@resource).read : fetch_xml.body

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

      lead[:publish_date] = lead[:publish_date] ? parse_date(lead[:publish_date]) : nil
      lead[:source] = model_class.source[:code]
      lead[:country] = 'GB'

      sanitize_entry(lead)
    end
  end
end
