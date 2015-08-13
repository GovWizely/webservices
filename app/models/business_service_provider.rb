class BusinessServiceProvider
  include Indexable

  self.settings = {
    index: {
      analysis: {
        analyzer:
                  { custom_analyzer:        {
                    tokenizer: 'standard',
                    filter:    %w(standard asciifolding lowercase snowball) },
                    title_keyword_analyzer: {
                      tokenizer: 'keyword',
                      filter:    %w(asciifolding lowercase) },
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
        ita_contact_email:   { type: 'string', index: 'not_analyzed' },
        company_name:        { type: 'string', analyzer: 'custom_analyzer' },
        company_phone:       { type: 'string', index: 'not_analyzed' },
        company_address:     { type: 'string', index: 'not_analyzed' },
        company_website:     { type: 'string', index: 'not_analyzed' },
        company_description: { type: 'string', analyzer: 'custom_analyzer' },
        company_email:       { type: 'string', index: 'not_analyzed' },
        ita_office:          { type: 'string', analyzer: 'title_keyword_analyzer' },
        contact_title:       { type: 'string', index: 'not_analyzed' },
        contact_name:        { type: 'string', analyzer: 'custom_analyzer' },
        category:            { type: 'string', analyzer: 'title_keyword_analyzer' },
      },
    },
  }.freeze

  self.source = {
    full_name: 'ITA',
    code:      'PARATURE',
  }
end
