module ScreeningList
  module Mappable
    def self.included(klass)
      klass.settings = {
        index: {
          analysis: {
            analyzer: {
              snowball_asciifolding_nostop: {
                tokenizer: 'standard',
                filter:    %w(standard asciifolding lowercase snowball),
              },
              standard_asciifolding_nostop: {
                analyzer:  'standard',
                tokenizer: 'standard',
                filter:    %w(standard asciifolding lowercase),
              },
              keyword_lowercase:            {
                tokenizer: 'keyword',
                filter:    %w(lowercase asciifolding),
              },
              keyword_uppercase:            {
                tokenizer: 'keyword',
                filter:    %w(uppercase asciifolding),
              },
            },
          },
        },
      }.freeze

      klass.mappings = {
        klass.name.typeize => {
          _timestamp: {
            enabled: true,
            store:   true,
          },
          properties: {
            # name variants
            name:                      { type:     'string',
                                         analyzer: 'standard_asciifolding_nostop',
                                         fields:   {
                                           keyword: { type: 'string', analyzer: 'keyword_lowercase' } } },

            name_idx:                  { type:     'string',
                                         analyzer: 'standard_asciifolding_nostop',
                                         fields:   {
                                           keyword: { type: 'string', analyzer: 'keyword_lowercase' } } },

            name_with_common:          { type:     'string',
                                         analyzer: 'standard_asciifolding_nostop',
                                         fields:   {
                                           keyword: { type: 'string', analyzer: 'keyword_lowercase' } } },

            alt_names:                 { type:     'string',
                                         analyzer: 'standard_asciifolding_nostop',
                                         fields:   {
                                           keyword: { type: 'string', analyzer: 'keyword_lowercase' } } },

            alt_names_idx:             { type:     'string',
                                         analyzer: 'standard_asciifolding_nostop',
                                         fields:   {
                                           keyword: { type: 'string', analyzer: 'keyword_lowercase' } } },

            alt_names_with_common:     { type:     'string',
                                         analyzer: 'standard_asciifolding_nostop',
                                         fields:   {
                                           keyword: { type: 'string', analyzer: 'keyword_lowercase' } } },

            # reversed
            rev_name:                  { type:     'string',
                                         analyzer: 'standard_asciifolding_nostop',
                                         fields:   {
                                           keyword: { type: 'string', analyzer: 'keyword_lowercase' } } },

            rev_name_with_common:      { type:     'string',
                                         analyzer: 'standard_asciifolding_nostop',
                                         fields:   {
                                           keyword: { type: 'string', analyzer: 'keyword_lowercase' } } },

            rev_alt_names:             { type:     'string',
                                         analyzer: 'standard_asciifolding_nostop',
                                         fields:   {
                                           keyword: { type: 'string', analyzer: 'keyword_lowercase' } } },

            rev_alt_with_common:       { type:     'string',
                                         analyzer: 'standard_asciifolding_nostop',
                                         fields:   {
                                           keyword: { type: 'string', analyzer: 'keyword_lowercase' } } },

            # whitespace removed
            trim_name:                 { type: 'string', analyzer: 'standard_asciifolding_nostop' },
            trim_name_with_common:     { type: 'string', analyzer: 'standard_asciifolding_nostop' },
            trim_alt_names:            { type: 'string', analyzer: 'standard_asciifolding_nostop' },
            trim_alt_with_common:      { type: 'string', analyzer: 'standard_asciifolding_nostop' },

            # whitespace removed and reversed
            trim_rev_name:             { type: 'string', analyzer: 'standard_asciifolding_nostop' },
            trim_rev_name_with_common: { type: 'string', analyzer: 'standard_asciifolding_nostop' },
            trim_rev_alt_names:        { type: 'string', analyzer: 'standard_asciifolding_nostop' },
            trim_rev_alt_with_common:  { type: 'string', analyzer: 'standard_asciifolding_nostop' },

            remarks:                   { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
            title:                     { type: 'string', analyzer: 'snowball_asciifolding_nostop' },

            type:                      { type: 'string', analyzer: 'keyword_lowercase' },
            source:                    { properties: { full_name: { type: 'string', index: 'no' },
                                                       code:      { type: 'string', analyzer: 'keyword' } } },
            federal_register_notice:   { type: 'string', analyzer: 'keyword' },

            ### Note to self: (I went back and forth so many times that I need a note to break me out of this loop)
            # uppercase is relevant here because
            addresses:                 { properties: { country:         { type: 'string', analyzer: 'keyword_uppercase' } } },
            # we currently use both filter/term and query/match on this field using different parameters (countries and address,
            # respectively) and we want the query/match not to care about casing.
            # This ensures the query gets analyzed and uppercased during search and the existing terms filter can remain as is.
            # I could mention that I intend to move those filter to use the filter/query but I won't. That might never happen :-P
            ###
            ids:                       { properties: { country:         { type: 'string', analyzer: 'keyword' },
                                                       issue_date:      { type: 'date',   format: 'YYYY-MM-dd' },
                                                       expiration_date: { type: 'date',   format: 'YYYY-MM-dd' } } },

            nationalities:             { type: 'string', analyzer: 'keyword' },
            citizenships:              { type: 'string', analyzer: 'keyword' },
            dates_of_birth:            { type: 'string', analyzer: 'keyword' },
            start_date:                { type: 'date',   format: 'YYYY-MM-dd' },
            end_date:                  { type: 'date',   format: 'YYYY-MM-dd' },

            entity_number:             { type: 'integer' },
          },
        },
      }.freeze

      klass.class_eval do
        class << self
          attr_accessor :source
        end
      end
    end
  end
end
