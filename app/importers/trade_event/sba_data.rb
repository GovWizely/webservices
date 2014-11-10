require 'open-uri'

module TradeEvent
  class SbaData
    include ::Importer

    attr_accessor :html_entities_coder, :reject_if_ends_before

    ENDPOINT = 'http://www.sba.gov/event-list/views/new_events_listing.xml?display_id=services_1&filters[event_topic][value]=6&limit=100&offset=0'

    def initialize(resource = ENDPOINT, options = {})
      @resource = resource
      self.reject_if_ends_before = options.fetch(:reject_if_ends_before, Date.current)
    end

    def import
      url = URI.parse(@resource)

      loop do
        docs = import_single(url.to_s)
        break unless docs.any?
        Sba.index remove_invalid(docs)
        url.query.sub!(/offset=(\d+)/) { "offset=#{Regexp.last_match[1].to_i + 100}" }
      end
    end

    private

    SINGLE_VALUED_XPATHS = {
      cost:              './fee',
      description:       './body',
      event_cancelled:   './event_cancelled',
      event_name:        './node_title',
      event_type:        './event_type',
      industries:        './industry',
      registration_link: './registration_website',
    }.freeze

    DATETIME_XPATHS = {
      event_date: './event_date',
      time_zone:  './time_zone',
    }

    CONTACT_XPATHS = {
      email:     './registration_email',
      last_name: './contact_name',
      phone:     './registration_phone',
      post:      './agency',
    }.freeze

    VENUE_XPATHS = {
      address: './street',
      city:    './city',
      country: './country',
      state:   './province',
      venue:   './location_name',
    }.freeze

    def import_single(url)
      Rails.logger.info "Importing #{url}"
      xml = Nokogiri::XML(open(url))
      xml.xpath('//result/item').map { |item| process_item(item) }
    end

    def process_item(item)
      doc = extract_fields(item, SINGLE_VALUED_XPATHS)

      doc.merge!(extract_date_and_time_fields(item))

      doc[:industries] = [doc[:industries]].compact
      doc[:source] = model_class.source
      doc[:contacts] = extract_contacts(item)
      doc[:venues] = extract_venues(item)
      doc[:id] = generate_id(doc)

      sanitize_entry(doc)
    end

    def extract_date_and_time_fields(item)
      fields = extract_fields(item, DATETIME_XPATHS)

      datetimes = fields[:event_date].split(' to ')
      fields[:start_date], fields[:start_time] = extract_date_and_time(datetimes[0])
      fields[:end_date], fields[:end_time] = datetimes[1] ?
        extract_date_and_time(datetimes[1]) :
        [fields[:start_date], nil]  # assume it ends on the same day it starts

      fields.delete(:event_date)
      fields
    end

    def extract_date_and_time(str)
      datetime = DateTime.parse(str)
      [datetime.to_date.iso8601, datetime.strftime('%H:%M')]
    end

    def extract_contacts(item)
      contact = extract_fields(item, CONTACT_XPATHS)
      contact.values.any? ? [contact] : []
    end

    def extract_venues(item)
      venue = extract_fields(item, VENUE_XPATHS)
      venue[:country] &&= lookup_country(venue[:country])
      venue[:state] &&= lookup_state(venue[:state]) rescue venue[:state]
      [venue]
    end

    def generate_id(doc)
      Digest::SHA1.hexdigest(
        %i(city cost country event_name event_type start_date
           start_time end_date end_time time_zone)
          .map { |f| doc[f] }.join)
    end

    def remove_invalid(docs)
      docs.select do |doc|
        valid = doc_valid?(doc)

        # We need event_cancelled as a key in the doc to check validity,
        # but don't want to actually import it as a field.
        doc.delete(:event_cancelled)
        valid
      end
    end

    def doc_valid?(doc)
      doc[:venues].first[:country] &&
        doc[:end_date] &&
        doc[:start_date] &&
        Date.parse(doc[:end_date]) >= reject_if_ends_before &&
        doc[:event_cancelled] != 'Has been canceled'
    end
  end
end
