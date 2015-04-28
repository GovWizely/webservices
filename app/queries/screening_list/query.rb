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
      @score = options[:score].try(:to_i) if options[:score].present?
    end

    def generate_query(json)
      multi_fields = %i(alt_names name remarks title)
      json.query do
        json.bool do
          json.must do
            json.child! { generate_multi_match(json, multi_fields, @q) } if @q
          end if @q

          if @name
            generate_score_query(json, @score)
          end

          if @address
            generate_fuzzy_queries(json, %w(addresses.address addresses.city addresses.state addresses.postal_code addresses.country), @address, operator = :and)
          end
        end
      end if [@q, @name, @distance, @address].any?
    end

    def generate_score_query(json, score)

      score ||= 0

      json.disable_coord true
      json.set! 'should' do
          # 100
          json.explain
          json.child! do
            json.function_score do
              json.boost_mode 'replace'
              json.query do
                json.multi_match do
                  json.query @name
                  json.fields ['name.keyword', 'alt_names.keyword',
                               'reversed_name.keyword', 'trimmed_name.keyword',
                               'reversed_alt_names.keyword', 'trimmed_alt_names.keyword']
                end
              end
              json.functions do
                json.child! { json.weight 5 }
              end
            end
          end

          # 95
          json.child! do
            json.function_score do
              json.boost_mode 'replace'
              json.query do
                json.multi_match do
                  json.query @name
                  json.fields ['name', 'alt_names', 'reversed_name', 'trimmed_name',
                               'reversed_alt_names', 'trimmed_alt_names',
                               'name.keyword', 'alt_names.keyword', 'reversed_name.keyword',
                               'trimmed_name.keyword', 'reversed_alt_names.keyword', 'trimmed_alt_names.keyword']
                  json.prefix_length 1
                  json.operator :and
                end
              end
              json.functions do
                json.child! { json.weight 5 }
              end
            end
          end

          # 90
          json.child! do
            json.function_score do
              json.boost_mode 'replace'
              json.query do
                json.multi_match do
                  json.query @name
                  json.fields ['name.keyword', 'alt_names.keyword',
                               'reversed_name.keyword', 'trimmed_name.keyword',
                               'reversed_alt_names.keyword', 'trimmed_alt_names.keyword']
                  json.prefix_length 1
                  json.fuzziness 1
                  json.operator :and
                end
              end
              json.functions do
                json.child! { json.weight 5 }
              end
            end
          end

          # 85
          json.child! do
            json.function_score do
              json.boost_mode 'replace'
              json.query do
                json.multi_match do
                  json.query @name
                  json.fields ['name', 'alt_names', 'reversed_name', 'trimmed_name',
                               'reversed_alt_names', 'trimmed_alt_names',
                               'name.keyword', 'alt_names.keyword', 'reversed_name.keyword',
                               'trimmed_name.keyword', 'reversed_alt_names.keyword', 'trimmed_alt_names.keyword']
                  json.prefix_length 1
                  json.fuzziness 1
                  json.operator :and
                end
              end
              json.functions do
                json.child! { json.weight 5 }
              end
            end
          end

          # 80
          json.child! do
            json.function_score do
              json.boost_mode 'replace'
              json.query do
                json.multi_match do
                  json.query @name
                  json.fields ['name.keyword', 'alt_names.keyword',
                               'reversed_name.keyword', 'trimmed_name.keyword',
                               'reversed_alt_names.keyword', 'trimmed_alt_names.keyword']
                  json.prefix_length 1
                  json.fuzziness 2
                  json.operator :and
                end
              end
              json.functions do
                json.child! { json.weight 5 }
              end
            end
          end

          # 75
          json.child! do
            json.function_score do
              json.boost_mode 'replace'
              json.query do
                json.multi_match do
                  json.query @name
                  json.fields ['name', 'alt_names', 'reversed_name', 'trimmed_name',
                               'reversed_alt_names', 'trimmed_alt_names',
                               'name.keyword', 'alt_names.keyword', 'reversed_name.keyword',
                               'trimmed_name.keyword', 'reversed_alt_names.keyword', 'trimmed_alt_names.keyword']
                  json.prefix_length 1
                  json.fuzziness 2
                  json.operator :and
                end
              end
              json.functions do
                json.child! { json.weight 75 }
              end
            end
          end

      end
    end

    def generate_fuzzy_queries(json, fields, value, operator)
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
