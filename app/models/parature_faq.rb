class ParatureFaq
  include Indexable

  self.settings = {
    index: {
      analysis: {
        analyzer:
                  {
                    custom_analyzer:       {
                      tokenizer: 'standard',
                      filter:    %w(standard asciifolding lowercase snowball),
                    },
                    phrase_match_analyzer: {
                      tokenizer: 'keyword',
                      filter:    'lowercase',
                    },
                  },
      },
    },
  }.freeze

  self.mappings = {
    name.typeize => {
      _timestamp: {
        enabled: true,
        store:   true,
      },
      dynamic:    'false',
      properties: {
        question:    { type: 'string', analyzer: 'custom_analyzer' },
        answer:      { type: 'string', analyzer: 'custom_analyzer' },
        update_date: { type: 'date', format: 'YYYY-MM-dd' },
        topic:       { type: 'string', analyzer: 'phrase_match_analyzer' },
        industry:    { type: 'string', analyzer: 'phrase_match_analyzer' },
        country:     { type: 'string' },
      },
    },
  }.freeze

  self.source = {
    full_name: 'ITA',
    code:      'PFAQ',
  }
  end
