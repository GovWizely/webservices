require 'open-uri'
require 'csv'

module TradeEvent
  class UstdaData < BaseData
    include Importable
    include VersionableResource

    attr_accessor :reject_if_ends_before

    ENDPOINT = 'https://www.ustda.gov/api/events/xml'
    CONTAINS_MAPPER_LOOKUPS = true

    SINGLE_VALUED_XPATHS = {
      event_name:         './Title',
      start_date:         './Start-Date',
      end_date:           './End-Date',
      start_time:         './Start-Time',
      end_time:           './End-Time',
      cost:               './Cost',
      cost_currency:      './Cost-Currency',
      registration_link:  './Registration-Link',
      registration_title: './Registration-Title',
      description:        './Body',
      industries:         './Industry',
      url:                './Learn-More-URL',
      first_name:         './First-Name',
      last_name:          './Last-Name',
      post:               './Post',
      person_title:       './Person_Title',
      phone:              './Phone',
      email:              './Email',
    }.freeze

    VENUE_XPATHS = {
      venue:   './Venue-%d',
      city:    './City-%d',
      state:   './State-%d',
      country: './Country-%d',
    }

    def initialize(resource = ENDPOINT, options = {})
      @resource = resource
      self.reject_if_ends_before = options.fetch(:reject_if_ends_before, Date.current)
    end

    def loaded_resource
      @loaded_resource ||= open(@resource, 'r:utf-8').read
    end

    def import
      Ustda.index(trade_events('//node'))
    end

    private

    def process_event_info(entry)
      event = extract_fields(entry, SINGLE_VALUED_XPATHS)

      event = process_dates_and_times(event)
      return nil if event[:end_date] && event[:end_date] < reject_if_ends_before
      event[:cost], event[:cost_currency] = cost(entry) if entry[:cost]

      event[:venues] = venues(entry)

      process_geo_fields(event)

      event[:event_type] = nil
      event[:source] = model_class.source[:code]
      event[:id] = Utils.generate_id(event, %i(event_name start_date
                                               event_time end_date end_time time_zone),)
      event[:industries] = [event[:industries]]

      event
    end

    def process_dates_and_times(event)
      event[:start_date] &&= extract_date(event[:start_date])
      event[:end_date] &&= extract_date(event[:end_date])
      event[:start_time] &&= extract_time(event[:start_time])
      event[:end_time] &&= extract_time(event[:end_time])
      event
    end

    def extract_date(date_str)
      date = Date.strptime(date_str, '%m/%d/%Y')
      valid_date?(date) ? date : nil
    rescue ArgumentError
      nil
    end

    def extract_time(time_str)
      Time.parse(time_str).strftime('%H:%M')
    end

    def valid_date?(date)
      Date.valid_date?(date.year, date.month, date.mday)
    end

    def cost(entry)
      cost = Monetize.parse(entry[:cost])
      [cost.to_f, cost.currency_as_string]
    end

    def venues(entry)
      (1..3).map do |venue_number|
        venue_xpaths = {}
        VENUE_XPATHS.each do |key, value|
          venue_xpaths[key] = value % venue_number
        end
        venue = extract_fields(entry, venue_xpaths)
        venue[:country] = get_missing_country(venue[:venue]) if venue[:country].blank? && !venue[:venue].blank?
        venue[:country_name] = begin
                                 venue[:country].dup
                               rescue
                                 nil
                               end
        venue[:country] = lookup_country(venue[:country]) unless venue[:country].blank?

        venue.values.all?(&:blank?) ? nil : venue
      end.compact
    end

    def process_geo_fields(event)
      event.merge! add_related_fields(event[:venues].map { |v| v[:country_name] })
    end
  end
end
