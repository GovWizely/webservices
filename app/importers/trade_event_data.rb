require 'open-uri'

class TradeEventData
  include Importer

  SINGLE_VALUED_XPATHS = {
    city:               './/CITY',
    cost:               './COST',
    country:            './/COUNTRY',
    description:        './DETAILDESC',
    end_date:           './EVENDDT',
    event_name:         './EVENTNAME',
    event_type:         './EVENTTYPE',
    id:                 './EVENTID',
    registration_link:  './REGISTRATIONLINK',
    registration_title: './REGISTRATIONTITLE',
    start_date:         './EVSTARTDT',
    state:              './/STATE',
    url:                './WEBSITES/WEBSITE/@URL',
    venue:              './/LOCATION',
  }.freeze

  CONTACT_XPATHS = {
    email:        './EMAIL',
    first_name:   './FIRSTNAME',
    last_name:    './LASTNAME',
    person_title: './TITLE',
    phone:        './PHONE',
    post:         './POST',
  }

  def initialize(resource = "http://emenuapps.ita.doc.gov/ePublic/GetEventXML?StartDT=#{Date.tomorrow.strftime('%m/%d/%Y')}&EndDT=01/01/2020")
    @resource = resource
  end

  def import
    Rails.logger.info "Importing #{@resource}"
    doc = Nokogiri::XML(open(@resource))
    trade_events = doc.xpath('//EVENTINFO').map do |event_info|
      trade_event = process_event_info(event_info)
      trade_event
    end.compact
    TradeEvent.index trade_events
  end

  private

  def process_event_info(event_info)
    event_hash = extract_from_event_info(event_info)
    process_required_fields(event_hash)

    if event_invalid?(event_hash)
      event_hash[:ttl] = '1s'
      return event_hash
    end

    process_optional_fields(event_hash)

    event_hash[:ttl] = "#{(event_hash[:end_date] - Date.current).to_i}d"
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
    event_hash
  end

  def process_optional_fields(event_hash)
    event_hash[:cost] = event_hash[:cost].to_f rescue nil if event_hash[:cost].present?
    event_hash[:url] = nil if event_hash[:url].present? && event_hash[:url] == 'YES'
  end

  def process_required_fields(event_hash)
    event_hash[:start_date] = process_date(event_hash[:start_date]) rescue nil
    event_hash[:end_date] = process_date(event_hash[:end_date]) rescue nil
    event_hash[:country] = event_hash[:country].present? ? lookup_country(event_hash[:country]) : nil
  end

  def process_date(date_string)
    Date.strptime(date_string, '%m/%d/%Y') rescue nil
  end

  def event_invalid?(event_hash)
    event_hash[:country].nil? ||
        event_hash[:end_date].nil? || event_hash[:start_date].nil? ||
        event_hash[:end_date] < Date.current
  end
end
