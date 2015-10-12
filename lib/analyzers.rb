module Analyzers
  mattr_reader :definitions
  @@definitions = {
    snowball_asciifolding_nostop:       {
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
    phrase_match_analyzer:             {
      tokenizer: 'keyword',
      filter:    'lowercase',
    },
    title_keyword_analyzer:            {
      tokenizer: 'keyword',
      filter:    %w(asciifolding lowercase),
    },
    case_insensitive_keyword_analyzer: {
      tokenizer: 'keyword',
      filter:    %w(standard lowercase),
    },
    location_name_analyzer:            {
      tokenizer: 'standard',
      filter:    %w(standard asciifolding lowercase synonym stopword),
    },
    location_name_sort:                {
      tokenizer: 'keyword',
      filter:    %w(lowercase asciifolding)
    },
    english_analyzer:                  {
      tokenizer: 'standard',
      filter:    %w(standard asciifolding lowercase snowball)
    },
    french_analyzer:                   {
      tokenizer: 'standard',
      filter:    %w(standard asciifolding lowercase french)
    },
    chinese_analyzer:                  {
      tokenizer: 'standard',
      filter:    %w(standard lowercase)
    },
    portuguese_analyzer:               {
      tokenizer: 'standard',
      filter:    %w(standard asciifolding lowercase portuguese)
    },
    spanish_analyzer:                  {
      tokenizer: 'standard',
      filter:    %w(standard asciifolding lowercase spanish)
    },
  }.freeze
end
