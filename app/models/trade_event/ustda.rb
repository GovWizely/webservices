module TradeEvent
  class Ustda
    extend ::Indexable
    include Mappable

    self.settings = {
      index: {
        analysis: {
          analyzer: { custom_analyzer: { type:      'custom',
                                         tokenizer: 'standard',
                                         filter:    %w(standard asciifolding lowercase snowball) },
          },
        },
      },
    }.freeze

    self.mappings = {
      ustda_event: {
        _ttl:       { enabled: true },
        properties: {
          :'venues.country' => { type: 'string', analyzer: 'keyword' },
          description: { type: 'string', analyzer: 'custom_analyzer' },
          end_date:    { type: 'date', format: 'YYYY-MM-dd' },
          event_name:  { type: 'string', analyzer: 'custom_analyzer' },
          industries:  { type: 'string', analyzer: 'custom_analyzer' },
          start_date:  { type: 'date', format: 'YYYY-MM-dd' },
          id:          { type: 'string', index: :not_analyzed, include_in_all: false },
        },
      },
    }.freeze

    self.source = 'USTDA'
  end
end
