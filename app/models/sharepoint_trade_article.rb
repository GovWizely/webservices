class SharepointTradeArticle
  include Indexable
  analyze_by :snowball_asciifolding_nostop, :keyword_lowercase

  settings.freeze

  self.mappings = {

    sharepoint_trade_article: {
      properties: {
        _updated_at:              { type: 'date', format: 'strictDateOptionalTime' },
        title:                    { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
        short_title:              { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
        summary:                  { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
        creation_date:            { type: 'date', format: 'YYYY-MM-dd' },
        release_date:             { type: 'date', format: 'YYYY-MM-dd' },
        expiration_date:          { type: 'date', format: 'YYYY-MM-dd' },
        source_agencies:          { type: 'string' },
        source_business_units:    { type: 'string' },
        source_offices:           { type: 'string' },
        evergreen:                { type: 'boolean' },
        content:                  { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
        keyword:                  { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
        export_phases:            { type: 'string', analyzer: 'keyword_lowercase' },
        industries:               { type: 'string', analyzer: 'keyword_lowercase' },
        countries:                { type: 'string', analyzer: 'keyword_lowercase' },
        trade_regions:            { type: 'string', analyzer: 'keyword_lowercase' },
        trade_programs:           { type: 'string', analyzer: 'keyword_lowercase' },
        trade_initiatives:        { type: 'string', analyzer: 'keyword_lowercase' },
        geo_regions:              { type: 'string', analyzer: 'keyword_lowercase' },
        geo_subregions:           { type: 'string', analyzer: 'keyword_lowercase' },
        topics:                   { type: 'string', analyzer: 'keyword_lowercase' },
        sub_topics:               { type: 'string', analyzer: 'keyword_lowercase' },
        seo_metadata_title:       { type: 'string' },
        seo_metadata_description: { type: 'string' },
        seo_metadata_keyword:     { type: 'string' },
        trade_url:                { type: 'string' },
        file_url:                 { type: 'string' },
        image_url:                { type: 'string' },
        url_html_source:          { type: 'string' },
        url_xml_source:           { type: 'string' },
      },
    },
  }.merge(metadata_mappings,).freeze

  self.source = {
    full_name: 'ITA',
    code:      'SPTA',
  }
end
