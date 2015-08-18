module ScreeningList
  module GenerateFuzzyAddressQuery
    def generate_fuzzy_address_query(json)
      stopwords    = %w( and the los )
      common_words = %w( box st ave )

      addr = %w(addresses.address)

      # name variants
      @address = @address.gsub(/[\]\[!"#$%&()*+,.:;<=>?@^_`{|}\/~]/, "")
      @address = @address.split.delete_if { |addr| stopwords.include?(addr.downcase) }.join(' ')
      @address = @address.split.delete_if { |addr| common_words.include?(addr.downcase) }.join(' ')

      single_token = addr

      score_hash = {
        score_100: { fields: single_token, fuzziness: 0, weight: 10 },
        # score_95:  { fields: all_fields, fuzziness: 0, weight: 5 },
        score_90:  { fields: single_token, fuzziness: 1, weight: 10 },
        # score_85:  { fields: all_fields, fuzziness: 1, weight: 5 },
        score_80:  { fields: single_token, fuzziness: 2, weight: 80 },
        # score_75:  { fields: all_fields, fuzziness: 2, weight: 75 },
      }

      json.disable_coord true
      json.set! 'should' do
        score_hash.each do |_key, value|
          json.child! do
            json.function_score do
              json.boost_mode 'replace'
              json.query do
                json.multi_match do
                  json.query @address
                  json.operator :and
                  json.fields value[:fields]
                  json.fuzziness value[:fuzziness]
                end
              end
              json.functions do
                json.child! { json.weight value[:weight] }
              end
            end
          end
        end
      end
    end
  end
end
