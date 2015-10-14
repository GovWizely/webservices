class MarketResearch
  include Indexable
  analyze_by :snowball_asciifolding_nostop, :keyword_asciifolding_lowercase

  settings.freeze

  self.mappings = {
    name.typeize => {
      properties: {
        expiration_date: { type: 'date', format: 'YYYY-MM-dd' },
        countries:       { type: 'string', analyzer: 'keyword' },
        description:     { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
        industries:      {
          type:   'string',
          fields: {
            tokenized: { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
            keyword:   { type: 'string', analyzer: 'keyword_asciifolding_lowercase' },
          },
        },
        ita_industries:  {
          type:   'string',
          fields: {
            tokenized: { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
            keyword:   { type: 'string', analyzer: 'keyword_asciifolding_lowercase' },
          },
        },
        title:           {
          type: 'string', analyzer: 'snowball_asciifolding_nostop',
          fields: {
            keyword: { type: 'string', analyzer: 'keyword_asciifolding_lowercase' },
          }
        },
      },
    },
  }.merge(metadata_mappings).freeze

  self.source = {
    full_name: 'ITA',
    code:      'MR',
  }
end
