class CountryFactSheet
  include Indexable

  self.settings = {}
  self.mappings = {}

  self.source = {
    full_name: 'CountryFactSheet',
    code:      'CountryFactSheet'
  }
end
