module ScreeningList
  class Query < ::Query
    attr_reader :countries, :sources

    def initialize(options = {})
      super
      %i( q name address ).each { |f| instance_variable_set("@#{f}", options[f]) }
      %i( end_date start_date issue_date expiration_date ).each do |f|
        instance_variable_set("@#{f}", options[f]) if options[f].present?
      end
      extract_other_options(options)
    end

    private

    def extract_other_options(options)
      @type = options[:type].try(:downcase)
      @countries = options[:countries].try { |c| c.upcase.split(',') }
      @sources   = options[:sources].try { |s| s.upcase.split(',') } || []
      @name = options[:name]
      @address = options[:address]
      @distance = options[:distance].try(:to_i)
      @end_date = options[:end_date] if options[:end_date].present?
      @start_date = options[:start_date] if options[:start_date].present?
      @issue_date = options[:issue_date] if options[:issue_date].present?
      @expiration_date = options[:expiration_date] if options[:expiration_date].present?
      @fuzzy_name = true if options[:fuzzy_name].present?
    end

    def generate_query(json)
      multi_fields = %i(alt_names name remarks title)
      json.query do
        json.bool do
          json.must do
            json.child! { generate_multi_match(json, multi_fields, @q) }
          end if @q

          if @name
            if @fuzzy_name
              generate_fuzzy_name_query(json)
            else
              json.must do
                json.child! { generate_multi_match(json, multi_fields, @name) }
              end
            end
          end

          if @address
            generate_fuzziness_queries(json, %w(addresses.address addresses.city addresses.state addresses.postal_code addresses.country), @address, operator = :and)
          end
        end
      end if [@q, @name, @distance, @address].any?
    end

    def generate_fuzzy_name_query(json)
      stopwords    = %w( and the los )
      common_words = %w( co company corp corporation inc incorporated limited ltd mr mrs ms organization sa sas llc )

      # name variants
      names         = %w( name_idx rev_name alt_names_idx rev_alt_names )
      names_kw      = %w( name_idx.keyword alt_names_idx.keyword rev_name.keyword
                          rev_alt_names.keyword )

      # name variants with 'common' words stripped
      names_wc      = %w( name_with_common alt_names_with_common rev_name_with_common
                          rev_alt_name_with_common )
      names_wc_kw   = %w( name_with_common.keyword alt_names_with_common.keyword
                          rev_name_with_common.keyword rev_alt_name_with_common.keyword)

      # search all trim names since common words aren't detected in
      # queries with no ws

      trim_names    = %w( trim_name trim_rev_name trim_alt_names trim_rev_alt_names
                          trim_name_with_common trim_rev_name_with_common trim_alt_with_common trim_rev_alt_with_common )

      @name = @name.gsub(/[[:punct:]]/, '')
      @name = @name.split.delete_if { |name| stopwords.include?(name.downcase) }.join(' ')

      if (@name.downcase.split & common_words).empty?
        single_token = names_kw + trim_names
        all_fields   = single_token + names
      else
        single_token = names_wc_kw + trim_names
        all_fields   = single_token + names_wc
      end

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

    def generate_fuzziness_queries(json, fields, value, operator)
      json.set! 'should' do
        json.child! { generate_multi_match(json, fields, value, operator) }
        json.child! do
          json.multi_match do
            json.fields fields
            json.query value
            json.fuzziness @distance
            json.prefix_length 1
          end
        end if @distance
      end
    end

    def generate_filter(json)
      json.filter do
        json.bool do
          json.must do
            json.child! { json.term { json.type @type } } if @type
            json.child! { json.terms { json.set! 'source.code', @sources } } if @sources.any?
            generate_date_range(json, 'start_date', @start_date) if @start_date
            generate_date_range(json, 'end_date', @end_date) if @end_date
            generate_date_range(json, 'ids.issue_date', @issue_date) if @issue_date
            generate_date_range(json, 'ids.expiration_date', @expiration_date) if @expiration_date
          end if @type || @sources.any? || @start_date || @end_date || @issue_date || @expiration_date
          json.set! 'should' do
            json.child! { json.terms { json.set! 'addresses.country', @countries } }
            json.child! { json.terms { json.set! 'ids.country', @countries } }
            json.child! { json.terms { json.nationalities @countries } }
            json.child! { json.terms { json.citizenships @countries } }
          end if @countries
        end
      end if @countries || @type || @sources.any? || @start_date || @end_date || @issue_date || @expiration_date
    end
  end
end
