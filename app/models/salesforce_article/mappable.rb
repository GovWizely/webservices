module SalesforceArticle
  module Mappable
    def self.included(klass)
      klass.analyze_by :snowball_asciifolding_nostop

      klass.settings.freeze

      klass.mappings = {
        klass.name.typeize => {
          _timestamp: {
            enabled: true,
            store:   true,
          },
          properties: {
            atom:                 { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
            business_unit:        { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
            chapter:              { type: 'string', analyzer: 'snowball_asciifolding_nostop' },

            first_published_date: { type: 'date', format: 'YYYY-MM-dd' },
            last_published_date:  { type: 'date', format: 'YYYY-MM-dd' },

            public_url:           { type: 'string', index: 'not_analyzed' },

            references:           { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
            section:              { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
            summary:              { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
            title:                { type: 'string', analyzer: 'snowball_asciifolding_nostop' },

            url_name:             { type: 'string', index: 'not_analyzed' },
            source:               { type: 'string', index: 'not_analyzed' },

            countries:            { type: 'string', index: 'not_analyzed' },
            industries:           { type: 'string', index: 'not_analyzed' },
            topics:               { type: 'string', index: 'not_analyzed' },
            trade_regions:        { type: 'string', index: 'not_analyzed' },
            world_regions:        { type: 'string', index: 'not_analyzed' },
          },
        },
      }.merge(klass.metadata_mappings).freeze

      klass.class_eval do
        class << self
          attr_accessor :source
        end
      end
    end
  end
end
