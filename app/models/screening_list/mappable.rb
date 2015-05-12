module ScreeningList
  module Mappable

    STOPWORDS = %w(and the los)

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
              lowercase_stop:               {
                tokenizer: 'keyword',
                filter:    %w(lowercase asciifolding stopword),
              },
            },
            filter:   {
              stopword: { type:        'stop',
                          ignore_case: true,
                          stopwords:   STOPWORDS.join(',') },
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
            name:                   { type:     'string',
                                      analyzer: 'standard_asciifolding_nostop',
                                      fields:   {
                                        keyword: { type: 'string', analyzer: 'keyword_lowercase' },
                                        stop:    { type: 'string', analyzer: 'lowercase_stop' } } },

            name_idx:               { type:     'string',
                                      analyzer: 'standard_asciifolding_nostop',
                                      fields:   {
                                        keyword: { type: 'string', analyzer: 'keyword_lowercase' },
                                        stop:    { type: 'string', analyzer: 'lowercase_stop' } } },

            name_no_common:         { type:     'string',
                                      analyzer: 'standard_asciifolding_nostop',
                                      fields:   {
                                        keyword: { type: 'string', analyzer: 'keyword_lowercase' },
                                        stop:    { type: 'string', analyzer: 'lowercase_stop' } } },

            alt_names:              { type:     'string',
                                      analyzer: 'standard_asciifolding_nostop',
                                      fields:   {
                                        keyword: { type: 'string', analyzer: 'keyword_lowercase' } } },

            alt_names_idx:          { type:     'string',
                                      analyzer: 'standard_asciifolding_nostop',
                                      fields:   {
                                        keyword: { type: 'string', analyzer: 'keyword_lowercase' } } },

            name_no_common:         { type:     'string',
                                      analyzer: 'standard_asciifolding_nostop',
                                      fields:   {
                                        keyword: { type: 'string', analyzer: 'keyword_lowercase' },
                                        stop:    { type: 'string', analyzer: 'lowercase_stop' } } },

            # reversed
            rev_name:               { type:     'string',
                                      analyzer: 'standard_asciifolding_nostop',
                                      fields:   {
                                        keyword: { type: 'string', analyzer: 'keyword_lowercase' } } },

            rev_no_common:          { type:     'string',
                                      analyzer: 'standard_asciifolding_nostop',
                                      fields:   {
                                        keyword: { type: 'string', analyzer: 'keyword_lowercase' } } },

            rev_alt_names:          { type:     'string',
                                      analyzer: 'standard_asciifolding_nostop',
                                      fields:   {
                                        keyword: { type: 'string', analyzer: 'keyword_lowercase' } } },

            rev_alt_no_common:      { type:     'string',
                                      analyzer: 'standard_asciifolding_nostop',
                                      fields:   {
                                        keyword: { type: 'string', analyzer: 'keyword_lowercase' } } },

            # whitespace removed
            trim_name:              { type:     'string',
                                      analyzer: 'standard_asciifolding_nostop',
                                      fields:   {
                                        keyword: { type: 'string', analyzer: 'keyword_lowercase' } } },

            trim_no_common:         { type:     'string',
                                      analyzer: 'standard_asciifolding_nostop',
                                      fields:   {
                                        keyword: { type: 'string', analyzer: 'keyword_lowercase' } } },

            trim_alt_names:         { type:     'string',
                                      analyzer: 'standard_asciifolding_nostop',
                                      fields:   {
                                        keyword: { type: 'string', analyzer: 'keyword_lowercase' } } },

            trim_alt_no_common:     { type:     'string',
                                      analyzer: 'standard_asciifolding_nostop',
                                      fields:   {
                                        keyword: { type: 'string', analyzer: 'keyword_lowercase' } } },

            # whitespace removed and reversed
            trim_rev_name:          { type:     'string',
                                      analyzer: 'standard_asciifolding_nostop',
                                      fields:   {
                                        keyword: { type: 'string', analyzer: 'keyword_lowercase' } } },

            trim_rev_no_common:     { type:     'string',
                                      analyzer: 'standard_asciifolding_nostop',
                                      fields:   {
                                        keyword: { type: 'string', analyzer: 'keyword_lowercase' } } },

            trim_rev_alt_names:     { type:     'string',
                                      analyzer: 'standard_asciifolding_nostop',
                                      fields:   {
                                        keyword: { type: 'string', analyzer: 'keyword_lowercase' } } },

            trim_rev_alt_no_common: { type:     'string',
                                      analyzer: 'standard_asciifolding_nostop',
                                      fields:   {
                                        keyword: { type: 'string', analyzer: 'keyword_lowercase' } } },

            remarks:                { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
            title:                  { type: 'string', analyzer: 'snowball_asciifolding_nostop' },

            type:                   { type: 'string', analyzer: 'keyword_lowercase' },
            source:                 { properties: { full_name: { type: 'string', index: 'no' },
                                                     code:      { type: 'string', analyzer: 'keyword' } } },
            federal_register_notice: { type: 'string', analyzer: 'keyword' },

            ### Note to self: (I went back and forth so many times that I need a note to break me out of this loop)
            # uppercase is relevant here because
            addresses:               { properties: { country:         { type: 'string', analyzer: 'keyword_uppercase' } } },
            # we currently use both filter/term and query/match on this field using different parameters (countries and address,
            # respectively) and we want the query/match not to care about casing.
            # This ensures the query gets analyzed and uppercased during search and the existing terms filter can remain as is.
            # I could mention that I intend to move those filter to use the filter/query but I won't. That might never happen :-P
            ###
            ids:                     { properties: { country:         { type: 'string', analyzer: 'keyword' },
                                                     issue_date:      { type: 'date',   format: 'YYYY-MM-dd' },
                                                     expiration_date: { type: 'date',   format: 'YYYY-MM-dd' } } },

            nationalities:           { type: 'string', analyzer: 'keyword' },
            citizenships:            { type: 'string', analyzer: 'keyword' },
            dates_of_birth:          { type: 'string', analyzer: 'keyword' },
            start_date:              { type: 'date',   format: 'YYYY-MM-dd' },
            end_date:                { type: 'date',   format: 'YYYY-MM-dd' },

            entity_number:           { type: 'integer' },
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
