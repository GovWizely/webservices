class Eccn
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
        description: { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
        eccn0:       { type: 'string', analyzer: 'keyword_asciifolding_lowercase' },
        eccn1:       { type: 'string', analyzer: 'keyword_asciifolding_lowercase' },
        eccn2:       { type: 'string', analyzer: 'keyword_asciifolding_lowercase' },
        eccn3:       { type: 'string', analyzer: 'keyword_asciifolding_lowercase' },
        eccn4:       { type: 'string', analyzer: 'keyword_asciifolding_lowercase' },
        url0:        { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
        url1:        { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
        url2:        { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
      },
    },
  }.merge(metadata_mappings).freeze

  self.source = {
    full_name: 'Eccn',
    code:      'ECCN',
  }
end
