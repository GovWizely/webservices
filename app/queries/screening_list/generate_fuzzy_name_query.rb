module ScreeningList
  module GenerateFuzzyNameQuery
    def generate_fuzzy_name_query(json)
      stopwords    = %w( and the los )
      common_words = %w( co company corp corporation inc incorporated limited ltd mr mrs ms organization sa sas llc )

      # name variants
      names         = %w( name_idx name_rev alt_idx alt_rev )
      names_kw      = %w( name_idx.keyword alt_idx.keyword name_rev.keyword alt_rev.keyword )
      name_no_wss   = %w( name_no_ws name_no_ws_rev alt_no_ws alt_no_ws_rev
                          name_no_ws_with_common name_no_ws_rev_with_common alt_no_ws_with_common alt_no_ws_rev_with_common )

      @name = @name.gsub(/[[:punct:]]/, '')
      @name = @name.split.delete_if { |name| stopwords.include?(name.downcase) }.join(' ')
      @name = @name.split.delete_if { |name| common_words.include?(name.downcase) }.join(' ')

      single_token = names_kw + name_no_wss
      all_fields   = single_token + names

      score_hash = {
        score_100: { fields: single_token, fuzziness: 0, weight: 10 },
        # score_95:  { fields: all_fields, fuzziness: 0, weight: 5 },
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
                  json.query @name
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
