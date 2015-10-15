module Analyzers
  mattr_reader :definitions
  @@definitions = {
    snowball_asciifolding_nostop:   {
      tokenizer: 'standard',
      filter:    %w(standard asciifolding lowercase snowball),
    },
    standard_asciifolding_nostop:   {
      analyzer:  'standard',
      tokenizer: 'standard',
      filter:    %w(standard asciifolding lowercase),
    },
    keyword_asciifolding_lowercase: {
      tokenizer: 'keyword',
      filter:    %w(lowercase asciifolding),
    },
    keyword_asciifolding_uppercase: {
      tokenizer: 'keyword',
      filter:    %w(uppercase asciifolding),
    },
    keyword_lowercase:              {
      tokenizer: 'keyword',
      filter:    %w(standard lowercase),
    },
    keyword_uppercase:              {
      tokenizer: 'keyword',
      filter:    %w(standard uppercase),
    },
  }.freeze
end
