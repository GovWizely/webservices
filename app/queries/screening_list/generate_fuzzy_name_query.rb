module ScreeningList
  module GenerateFuzzyNameQuery
    def generate_fuzzy_name_query(json)
      multi_word_query = @name =~ /\s/ ? true : false
      if multi_word_query
        names         = %w( name_idx name_rev alt_idx alt_rev )
        names_kw      = %w( name_idx.keyword alt_idx.keyword name_rev.keyword alt_rev.keyword )
        name_no_wss   = %w( name_no_ws name_no_ws_rev alt_no_ws alt_no_ws_rev
                            name_no_ws_with_common name_no_ws_rev_with_common alt_no_ws_with_common alt_no_ws_rev_with_common )

        single_token = names_kw + name_no_wss
        all_fields   = single_token + names

        score_hash = {
          # full string matches
          full_string_0:      { fields: single_token, fuzziness: 0, weight: 5 },
          full_string_1:      { fields: single_token, fuzziness: 1, weight: 5 },
          full_string_2:      { fields: single_token, fuzziness: 2, weight: 5 },

          # individual token matches
          individual_token_0: { fields: all_fields, fuzziness: 0, weight: 5 },
          individual_token_1: { fields: all_fields, fuzziness: 1, weight: 5 },
          individual_token_2: { fields: all_fields, fuzziness: 2, weight: 75 },
        }
      else
        name_variants = %w( name_idx
                            alt_idx
                            name_no_ws
                            name_no_ws_rev
                            alt_no_ws
                            alt_no_ws_rev
                            name_no_ws_with_common
                            alt_no_ws_with_common )

        score_hash = {
          individual_token_0: { fields: name_variants, fuzziness: 0, weight: 5 },
          individual_token_1: { fields: name_variants, fuzziness: 1, weight: 5 },
          individual_token_2: { fields: name_variants, fuzziness: 2, weight: 90 },
        }
      end

      json.disable_coord true
      json.minimum_should_match 1
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
