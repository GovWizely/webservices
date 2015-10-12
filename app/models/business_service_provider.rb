class BusinessServiceProvider
  include Indexable
  analyze_by :snowball_asciifolding_nostop, :keyword_asciifolding_lowercase

  settings.freeze

  self.mappings = {
    name.typeize => {
      _timestamp: {
        enabled: true,
        store:   true,
      },
      dynamic:    'false',
      properties: {
        ita_contact_email:   { type: 'string', index: 'not_analyzed' },
        company_name:        { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
        company_phone:       { type: 'string', index: 'not_analyzed' },
        company_address:     { type: 'string', index: 'not_analyzed' },
        company_website:     { type: 'string', index: 'not_analyzed' },
        company_description: { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
        company_email:       { type: 'string', index: 'not_analyzed' },
        ita_office:          { type: 'string', analyzer: 'keyword_asciifolding_lowercase' },
        contact_title:       { type: 'string', index: 'not_analyzed' },
        contact_name:        { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
        category:            { type: 'string', analyzer: 'keyword_asciifolding_lowercase' },
      },
    },
  }.freeze

  self.source = {
    full_name: 'ITA',
    code:      'PARATURE',
  }
end
