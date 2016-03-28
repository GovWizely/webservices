require 'csv'

## SeparatedValuesable model concern:
#
# Adds as_csv and as_tsv methods to your model. Usage:
#
#   class MyModel
#     include SeparatedValuesable
#     self.separated_values_config = [
#       :foo,
#       { bar: [:do, :re] }
#     ]
#   end
#
#   MyModel.as_csv( MyModel.search_for(options) )  # returns string
#
## Config:
#
# The config array can contain two types of config:
#
# - Symbol: which means "include this field as-is from the search result".
# - Hash: handles nested documents. The key is the field to include, and the
#   value (which should be an array) determines which keys from the nested
#   document should be concatenated together (the Hash should only have one
#   key/value pair). See the specs for examples of how this works.
#
## Limitations:
#
# - The serialization of nested/array documents is done for readability rather
#   than parsability. i.e. if the separators used are present in the value
#   they won't be escaped. If a use-case comes up that requires serialized
#   values to be programmatically parsable, the #to_row method will have to be
#   adjusted accordingly.

module SeparatedValuesable
  extend ActiveSupport::Concern

  module ClassMethods
    mattr_accessor :separated_values_config

    def as_csv(search_results)
      as_xsv(search_results)
    end

    def as_tsv(search_results)
      as_xsv(search_results, "\t")
    end

    private

    def as_xsv(search_results, col_sep = ',')
      CSV.generate(col_sep: col_sep) do |csv|
        csv << headers
        search_results.each do |result|
          csv << to_row(result[:_source])
        end
      end
    end

    def headers
      separated_values_config.map do |c|
        c.instance_of?(Hash) ? c.keys.first : c
      end
    end

    def to_row(result)
      separated_values_config.map do |config|
        if config.instance_of?(Symbol)
          value = result[config]
          value.instance_of?(Array) ? semicolon_join(value) : value
        else
          field, keys_to_concat = config.first
          value = result[field]

          if value.instance_of?(Array)
            semicolon_join(value.map { |v| comma_join(v, keys_to_concat) })
          elsif value
            comma_join(value, keys_to_concat)
                    end
        end
      end
    end

    def semicolon_join(values)
      values.reject { |v| v.to_s.empty? }.join('; ')
    end

    def comma_join(value, keys_to_concat)
      keys_to_concat.map { |k| value[k] }.reject { |v| v.to_s.empty? }.join(', ')
    end
  end
end
