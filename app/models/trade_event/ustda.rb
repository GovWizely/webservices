module TradeEvent
  class Ustda
    extend ::Indexable
    include TradeEvent::Mappable
    self.source = 'USTDA'

    self.mappings = mappings.dup
    mappings[to_s.typeize][:properties].merge!(:'venues.country' => { type: 'string', analyzer: 'keyword' },
                                               :'venues.city'    => { type: 'string', analyzer: 'custom_analyzer'                                                 }).freeze
  end
end
