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

    include ScreeningList::GenerateFuzzyNameQuery

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
      @fuzzy_name = true if options[:fuzzy_name].present? && options[:fuzzy_name].try(:downcase) == 'true'
    end

    def generate_query(json)
      multi_fields = %i(alt_names name remarks title)
      name_fields = %i(alt_names name)
      if @name && @fuzzy_name
        remove_stops
        json.highlight do
          json.fields do
            json.alt_idx({})
            json.alt_no_ws({})
            json.alt_no_ws_rev({})
            json.alt_no_ws_with_common({})
            json.name_idx({})
            json.name_no_ws({})
            json.name_no_ws_rev({})
            json.name_no_ws_with_common({})
          end
          json.order 'score'
        end
      end
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
                json.child! { generate_multi_match(json, name_fields, @name) }
              end
            end
          end

          if @address
            generate_fuzziness_queries(json, %w(addresses.address addresses.city addresses.state addresses.postal_code addresses.country), @address)
          end
        end
      end if [@q, @name, @distance, @address].any?
    end

    def generate_fuzziness_queries(json, fields, value)
      json.set! 'should' do
        json.child! { generate_multi_match(json, fields, value) }
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
            json.child! { json.terms { json.country @countries } }
          end if @countries
        end
      end if @countries || @type || @sources.any? || @start_date || @end_date || @issue_date || @expiration_date
    end
  end
end
