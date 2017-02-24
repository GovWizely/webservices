module ModelBuilder
  TEMPLATE_PATH = 'lib/elasticsearch/templates/document.rb.erb'.freeze
  TYPE_TO_MAPPING = { enum:    { type:    String,
                                 mapping: {
                                   type:     'text',
                                   analyzer: 'keyword_lowercase',
                                   fields:   {
                                     raw: {
                                       type: 'keyword',
                                     },
                                   }, }, },
                      integer: { type: Integer, mapping: { type: 'long' } },
                      float:   { type: Float, mapping: { type: 'float' } },
                      date:    { type: DateTime, mapping: { type: 'date' } },
                      string:  { type:    String,
                                 mapping: {
                                   type:     'text',
                                   analyzer: 'snowball_asciifolding_nostop',
                                   fields:   {
                                     raw: {
                                       type: 'keyword',
                                     },
                                   }, }, }, }.with_indifferent_access

  def self.load_model_class(data_source)
    template = ERB.new(Rails.root.join(TEMPLATE_PATH).read, nil, '<>').result(binding)
    eval(template, binding, __FILE__, __LINE__)
  end
end
