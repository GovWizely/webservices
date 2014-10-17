class ParatureFaq
  extend Indexable
  extend Model::CanDeleteOldDocuments

  self.settings = {
    index: {
      analysis: {
        analyzer:
                  { custom_analyzer: {
                    tokenizer: 'standard',
                    filter:    %w(standard asciifolding lowercase snowball) },
            },
      },
    },
  }.freeze

  mappings = {
    dynamic:    false,
    properties: {
      question:    { type: 'string', analyzer: 'custom_analyzer' },
      answer:      { type: 'string', analyzer: 'custom_analyzer' },
      update_date: { type: 'date', format: 'YYYY-MM-dd' },
      topic:       { type: 'string', analyzer: 'custom_analyzer' },
      industry:    { type: 'string', analyzer: 'custom_analyzer'  },
      country:     { type: 'string', analyzer: 'custom_analyzer'  },
      id:          { type: 'integer' },
    },
  }.freeze
  self.mappings[:parature_faq].merge!(mappings)
end
