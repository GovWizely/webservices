class TradeArticle
  extend Indexable

  self.settings = {}
  self.mappings = {
      trade_article: {
          dynamic: false,
          properties: {
              content: { type: 'string', analyzer: 'snowball' },
              title: { type: 'string', analyzer: 'snowball' },
              evergreen: { type: 'boolean' },
              pub_date: { type: 'date' },
              update_date: { type: 'date' },
              id: { type: 'string', index: :not_analyzed, include_in_all: false }
          }
      }
  }.freeze

end
