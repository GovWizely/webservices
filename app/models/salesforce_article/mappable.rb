module SalesforceArticle
  module Mappable
    def self.included(klass)
      klass.import_rate = 'Daily'
      klass.analyze_by :snowball_asciifolding_nostop

      klass.settings.freeze

      klass.mappings = {
        klass.name.typeize => {
          properties: {
            _updated_at:          { type: 'date', format: 'strictDateOptionalTime' },

            first_published_date: { type: 'date', format: 'YYYY-MM-dd' },
            last_published_date:  { type: 'date', format: 'YYYY-MM-dd' },

            url:                  { type: 'keyword' },

            references:           { type: 'text', analyzer: 'snowball_asciifolding_nostop' },
            summary:              { type: 'text', analyzer: 'snowball_asciifolding_nostop' },
            title:                { type: 'text', analyzer: 'snowball_asciifolding_nostop' },

            url_name:             { type: 'keyword' },
            source:               { type: 'keyword' },

            countries:            { type: 'keyword' },
            industries:           { type: 'keyword' },
            topics:               { type: 'keyword' },
            trade_regions:        { type: 'keyword' },
            world_regions:        { type: 'keyword' },

            atom:                 { type: 'text', analyzer: 'snowball_asciifolding_nostop' },
          },
        },
      }.merge(klass.metadata_mappings,).freeze

      klass.class_eval do
        class << self
          attr_accessor :source
        end
      end
    end
  end
end
