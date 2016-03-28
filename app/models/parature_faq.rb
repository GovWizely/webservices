class ParatureFaq
  include Indexable
  analyze_by :snowball_asciifolding_nostop, :keyword_lowercase

  settings.freeze

  self.mappings = {
    name.typeize => {
      dynamic:    'false',
      properties: {
        _updated_at:    { type: 'date', format: 'strictDateOptionalTime' },
        question:       { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
        answer:         { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
        update_date:    { type: 'date', format: 'YYYY-MM-dd' },
        topic:          { type: 'string', analyzer: 'keyword_lowercase' },
        industry:       { type: 'string', analyzer: 'keyword_lowercase' },
        country:        { type: 'string', analyzer: 'keyword_lowercase' },
        ita_industries: { type: 'string', analyzer: 'keyword_lowercase' },
      },
    },
  }.merge(metadata_mappings,).freeze

  self.source = {
    full_name: 'ITA',
    code:      'PFAQ',
  }
end
