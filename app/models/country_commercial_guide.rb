class CountryCommercialGuide
  include Indexable
  analyze_by :snowball_asciifolding_nostop, :keyword_asciifolding_lowercase

  settings.freeze

  self.mappings = {
    country_commercial_guide: {
      _timestamp: {
        enabled: true,
        store:   true,
      },
      dynamic:    'false',
      properties: {
        pdf_title:     { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
        pdf_chapter:   { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
        pdf_section:   { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
        pdf_url:       { type: 'string' },

        section_title: { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
        country:       { type: 'string', analyzer: 'keyword_asciifolding_lowercase' },
        industry:      { type: 'string', analyzer: 'keyword_asciifolding_lowercase' },
        topic:         { type: 'string', analyzer: 'keyword_asciifolding_lowercase' },
        content:       { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
        section_url:   { type: 'string' },
      },
    },
  }.merge(metadata_mappings).freeze

  self.source = {
    full_name: 'Country Commercial Guide',
    code:      'CCG',
  }
end
