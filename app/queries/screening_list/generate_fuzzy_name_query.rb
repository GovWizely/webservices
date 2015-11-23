module ScreeningList
  module GenerateFuzzyNameQuery
    def generate_fuzzy_name_query(json)
      stopwords    = %w( and the los )
      common_words = %w( co company corp corporation inc incorporated limited ltd mr mrs ms organization sa sas llc )

      # name variants
      name_variants = %w( name_idx
                          alt_idx
                          name_no_ws
                          name_no_ws_rev
                          alt_no_ws
                          alt_no_ws_rev
                          name_no_ws_with_common
                          alt_no_ws_with_common )

      @name = @name.gsub(/[^\p{Alnum}\p{Space}]/, '')
      @name = @name.split.delete_if { |name| stopwords.include?(name.downcase) }.join(' ')
      @name = @name.split.delete_if { |name| common_words.include?(name.downcase) }.join(' ')

      score_hash = {
        individual_token_0: { fields: name_variants, fuzziness: 0, weight: 5 },
        individual_token_1: { fields: name_variants, fuzziness: 1, weight: 5 },
        individual_token_2: { fields: name_variants, fuzziness: 2, weight: 90 },
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
