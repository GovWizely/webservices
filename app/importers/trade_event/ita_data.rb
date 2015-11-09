require 'open-uri'

module TradeEvent
  class ItaData
    include Importable
    include ::VersionableResource

    ENDPOINT = "http://emenuapps.ita.doc.gov/ePublic/GetEventXML?StartDT=#{Date.tomorrow.strftime('%m/%d/%Y')}&EndDT=01/01/2020"

    SINGLE_VALUED_XPATHS = {
      cost:               './COST',
      description:        './DETAILDESC',
      end_date:           './EVENDDT',
      event_name:         './EVENTNAME',
      event_type:         './EVENTTYPE',
      id:                 './EVENTID',
      registration_link:  './REGISTRATIONLINK',
      registration_title: './REGISTRATIONTITLE',
      start_date:         './EVSTARTDT',
      url:                './WEBSITES/WEBSITE/@URL',
    }.freeze

    CONTACT_XPATHS = {
      email:        './EMAIL',
      first_name:   './FIRSTNAME',
      last_name:    './LASTNAME',
      person_title: './TITLE',
      phone:        './PHONE',
      post:         './POST',
    }.freeze

    VENUE_XPATHS = {
      city:    './/CITY',
      country: './/COUNTRY',
      state:   './/STATE',
      venue:   './/LOCATION',
    }.freeze

    def import
      doc = Nokogiri::XML(loaded_resource, nil, 'ISO-8859-1')
      trade_events = doc.xpath('//EVENTINFO').map do |event_info|
        trade_event = process_event_info(event_info)
        trade_event
      end.compact
      Ita.index(trade_events)
    end

    private

    def process_event_info(event_info)
      event_hash = extract_from_event_info(event_info)
      process_required_fields(event_hash)

      return nil if event_invalid?(event_hash)

      process_optional_fields(event_hash)

      event_hash[:source] = model_class.source[:code]
      event_hash
    end

    def extract_from_event_info(event_info)
      event_hash = extract_fields(event_info, SINGLE_VALUED_XPATHS)
      event_hash[:contacts] = event_info.xpath('./CONTACT').map do |contact|
        extract_fields contact, CONTACT_XPATHS
      end
      event_hash[:industries] = event_info.xpath('./INDUSTRY').map do |industry|
        extract_node industry
      end.compact.uniq
      event_hash[:venues] = extract_venues(event_info)
      event_hash
    end

    def extract_venues(event_info)
      venue = extract_fields(event_info, VENUE_XPATHS)
      venue[:country] = venue[:country].present? ? lookup_country(venue[:country]) : nil
      [venue]
    end

    def process_optional_fields(event_hash)
      event_hash[:cost] = event_hash[:cost].to_f rescue nil if event_hash[:cost].present?
      event_hash[:url] = nil if event_hash[:url].present? && event_hash[:url] == 'YES'
    end

    def process_required_fields(event_hash)
      event_hash[:start_date] = process_date(event_hash[:start_date]) rescue nil
      event_hash[:end_date] = process_date(event_hash[:end_date]) rescue nil
    end

    def process_date(date_string)
      Date.strptime(date_string, '%m/%d/%Y') rescue nil
    end

    def event_invalid?(event_hash)
      event_hash[:venues].first[:country].nil? ||
        event_hash[:end_date].nil? || event_hash[:start_date].nil? ||
        event_hash[:end_date] < Date.current
    end
  end
end
