require 'open-uri'
require 'csv'

module TradeEvent
  class UstdaData
    include ::Importer

    ENDPOINT = 'http://www.ustda.gov/events/USTDATradeEvents.csv'

    COLUMN_HASH = {
      id:                 :id,
      event_name:         :event_name,
      description:        :description,
      start_date:         :start_date,
      end_date:           :end_date,
      cost:               :cost,
      registration_link:  :registration_link,
      registration_title: :registration_title,
      url:                :url,
      industry:           :industries,
    }.freeze

    EMPTY_RECORD = {
      id:                 '',
      event_name:         '',
      description:        '',
      start_date:         '',
      end_date:           '',
      cost:               '',
      cost_currency:      '',
      registration_link:  '',
      registration_title: '',
      url:                '',
      venues:             [],
      event_type:         '',
      industries:         [],
      contacts:           [],
      source:             '',
    }.freeze

    def initialize(resource = ENDPOINT)
      @resource = resource
    end

    def import
      Rails.logger.info "Importing #{@resource}"
      Ustda.index events
    end

    def events
      fh = open(@resource, 'r:UTF-8')
      fh.readline # Remove 'Last Updated: ...'
      content = fh.read.encode('UTF-16le', invalid: :replace, replace: '').encode('UTF-8')
      doc = CSV.parse(content, headers: true, header_converters: :symbol, encoding: 'UTF-8')
      doc.map { |entry| process_entry entry.to_h }.compact
    end

    private

    def process_entry(entry)
      event = sanitize_entry remap_keys(COLUMN_HASH, entry)

      %i(start_date end_date).each do |field|
        event[field] = Date.strptime(event[field], '%m/%d/%Y').iso8601 rescue nil if event[field]
      end

      event[:cost], event[:cost_currency] = cost(entry) if entry[:cost]
      event[:country] &&= lookup_country(event[:country])
      event[:industries] = Array(event[:industries])
      event[:contacts] = contact(entry)
      event[:venues] = venues(entry)
      event[:source] = model_class.source[:code]

      EMPTY_RECORD.dup.merge(event)
    end

    def cost(entry)
      cost = Monetize.parse(entry[:cost])
      [cost.to_f, cost.currency_as_string]
    end

    def contact(entry)
      [
        entry
          .slice(:first_name, :last_name, :post, :person_title, :phone, :email)
          .map { |k, v| { k => v.blank? ? '' : v.strip } }
          .reduce(:merge),
      ]
    end

    def venues(entry)
      (1..6).map do|id|
        fields = %w(country state city venue).map { |fname| "#{fname}#{id}".to_sym }
        venue = entry
                  .slice(*fields)
                  .map do |k, v|
                    { k.to_s.chop => v.blank? ? '' : v.strip }
                  end
                  .reduce(:merge)
                  .symbolize_keys
        venue[:country] = lookup_country(venue[:country]) unless venue[:country].blank?
        venue.values.all?(&:blank?) ? nil : venue
      end.compact
    end
  end
end
