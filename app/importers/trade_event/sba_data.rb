require 'net/https'

module TradeEvent
  class SbaData
    include ::Importer

    attr_accessor :html_entities_coder, :reject_if_ends_before

    ENDPOINT = 'https://www.sba.gov/event-list/views/new_events_listing?display_id=services_1&filters[event_topic][value]=6&limit=100&offset=0'
    HEADER = { 'Accept' => 'application/xml' }

    def initialize(resource = ENDPOINT, options = {}, header = HEADER)
      @resource = resource
      self.reject_if_ends_before = options.fetch(:reject_if_ends_before, Date.current)
      @header = header
    end

    def import
      iterate_over_source_urls do |_body, docs|
        Sba.index(remove_invalid(docs))
      end
    end

    def available_version
      checksums = []
      iterate_over_source_urls do |body, _docs|
        checksums.push(Digest::SHA1.hexdigest(body))
      end
      checksums.join
    end

    private

    def iterate_over_source_urls
      url = URI.parse(@resource)
      loop do
        body = get_url_body(url.to_s)
        docs = extract_docs(body)
        break unless docs.any?
        yield(body, docs)
        url.query.sub!(/offset=(\d+)/) { "offset=#{Regexp.last_match[1].to_i + 100}" }
      end
    end

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

    def extract_docs(body)
      xml = Nokogiri::XML(body)
      xml.xpath('//result/item').map { |item| process_item(item) }
    end

    def get_url_body(url)
      url =~ /^http/ ? open_with_tlsv1(url) : File.open(url).read
    end

    # :nocov:
    def open_with_tlsv1(url)
      uri = URI(url)
      Net::HTTP.start(uri.host, uri.port, use_ssl: true, ssl_version: :TLSv1) do |http|
        request = Net::HTTP::Get.new(uri, @header)
        http.request(request).body
      end
    end
    # :nocov:

    def process_item(item)
      doc = extract_fields(item, SINGLE_VALUED_XPATHS)

      doc.merge!(extract_date_and_time_fields(item))

      doc[:industries] = [doc[:industries]].compact
      doc[:source] = model_class.source[:code]
      doc[:contacts] = extract_contacts(item)
      doc[:venues] = extract_venues(item)
      doc[:id] = Utils.generate_id(doc, %i(city cost country event_name event_type start_date
                                           start_time end_date end_time time_zone))
      doc[:cost] &&= doc[:cost].gsub(/\s+/, '')

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
      [sanitize_entry(venue)]
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
