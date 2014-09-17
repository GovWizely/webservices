class FbopenLead
  extend Indexable

  self.settings = {
    index: {
      analysis: {
        analyzer: {
          custom_analyzer:        {
            tokenizer: 'standard',
            filter:    %w(standard asciifolding lowercase snowball),
          },
          title_keyword_analyzer: {
            tokenizer: 'keyword',
            filter:    %w(asciifolding lowercase),
          },
        },
      },
    },
  }.freeze

  self.mappings = {
    fbopen_lead: {
      properties: {
        country:         { type: 'string', analyzer: 'keyword' },
        description:     { type: 'string', analyzer: 'custom_analyzer' },
        contract_number: { type: 'string', index: 'not_analyzed' },
        industry:        { type: 'string', analyzer: 'custom_analyzer' },
        title:           {
          type:   'multi_field',
          fields: {
            title:   { type: 'string', analyzer: 'custom_analyzer' },
            keyword: { type: 'string', analyzer: 'title_keyword_analyzer' },
            raw:     { type: 'string', index: 'not_analyzed' },
          },
        },
        publish_date:    { type: 'date' },
        end_date:        { type: 'date' },
      },
    },
  }.freeze
end
