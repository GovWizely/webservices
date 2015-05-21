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
      @fuzzy = true if options[:fuzzy].present?
    end

    def generate_query(json)
      multi_fields = %i(alt_names name remarks title)
      json.query do
        json.bool do
          json.must do
            json.child! { generate_multi_match(json, multi_fields, @q) }
          end if @q

          if @name
            if @fuzzy
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
      keyword_fields = [
        'name_idx.keyword', 'name_no_common.keyword', 'alt_names_idx.keyword', 'alt_names_no_common.keyword',
        'rev_name.keyword', 'rev_no_common.keyword', 'rev_alt_names.keyword', 'rev_alt_no_common.keyword'
      ]

      non_keyword_fields = [
        'name_idx', 'name_no_common', 'alt_names_idx ', 'alt_names_no_common ',
        'rev_name', 'rev_no_common', 'rev_alt_names ', 'rev_alt_no_common',
        'trim_name', 'trim_name_no_common', 'trim_alt_names', 'trim_alt_no_common',
        'trim_rev_name', 'trim_rev_name_no_common', 'trim_rev_alt_names', 'trim_rev_alt_no_common'
      ]

      all_fields = non_keyword_fields + keyword_fields

      # common_words = %w(co company corp corporation inc incorporated limited ltd mr mrs ms organization sa sas llc)
      #
      # # name variants
      # names         = %w( name_idx alt_names_idx rev_name rev_alt_names )
      # names_kw      = %w( name_idx.keyword alt_names_idx.keyword rev_name.keyword rev_alt_names.keyword )
      # trim_names    = %w( trim_name trim_rev_name trim_alt_names trim_rev_alt_names )
      #
      # # name variants with 'common' words stripped
      # names_nc      = %w( name_no_common alt_names_no_common rev_name_no_common rev_alt_name_no_common )
      # names_nc_kw   = %w( name_no_common.keyword alt_names_no_common.keyword rev_name_no_common.keyword rev_alt_name_no_common.keyword)
      # trim_names_nc = %w( trim_name_no_common trim_rev_name_no_common trim_alt_no_common trim_rev_alt_no_common )
      #
      # if (@name.downcase.split & common_words).empty?
      #   keyword_fields = names_kw + trim_names
      #   all_fields     = keyword_fields + names
      # else
      #   keyword_fields = names_kw + names_nc_kw + trim_names + trim_names_nc
      #   all_fields     = keyword_fields + names + names_nc
      # end

      score_hash = {
        score_100: { fields: keyword_fields, fuzziness: 0, weight: 5 },
        score_95:  { fields: all_fields, fuzziness: 0, weight: 5 },
        score_90:  { fields: keyword_fields, fuzziness: 1, weight: 5 },
        score_85:  { fields: all_fields, fuzziness: 1, weight: 5 },
        score_80:  { fields: keyword_fields, fuzziness: 2, weight: 5 },
        score_75:  { fields: all_fields, fuzziness: 2, weight: 75 }
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
