module ScreeningList
  module GenerateFuzzyAddressQuery
    def generate_fuzzy_address_query(json)
      stopwords    = %w( and the los )
      common_words = %w( box st ave )

      # address variants
      addrs        = %w( address_idx address_rev  )
      addrs_kw     = %w( address_idx.keyword address_rev.keyword  )
      addrs_no_wss = %w( address_no_ws address_no_ws_rev
                         address_no_ws_with_common address_no_ws_rev_with_common )

      @address = @address.gsub(/[\]\[!"#$%&()*+,.:;<=>?@^_`{|}\/~]/, '')
      @address = @address.split.delete_if { |addr| stopwords.include?(addr.downcase) }.join(' ')
      @address = @address.split.delete_if { |addr| common_words.include?(addr.downcase) }.join(' ')

      single_token = addrs_kw + addrs_no_wss
      all_fields   = single_token + addrs

      score_hash = {
        score_100: { fields: single_token, fuzziness: 0, weight: 5 },
        score_95:  { fields: all_fields, fuzziness: 0, weight: 5 },
        score_90:  { fields: single_token, fuzziness: 1, weight: 5 },
        score_85:  { fields: all_fields, fuzziness: 1, weight: 5 },
        score_80:  { fields: single_token, fuzziness: 2, weight: 5 },
        score_75:  { fields: all_fields, fuzziness: 2, weight: 75 },
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
