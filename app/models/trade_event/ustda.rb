module TradeEvent
  class Ustda
    extend ::Indexable
    include TradeEvent::Mappable

    self.mappings = self.mappings.dup
    self.mappings[to_s.typeize][:properties].merge!({
      :'venues.country' => { type: 'string', analyzer: 'keyword' },
      :'venues.city' => { type: 'string', analyzer: 'custom_analyzer' },
    }).freeze

    self.source = 'USTDA'
  end
end
