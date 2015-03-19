module ScreeningList
  class Query < ::Query
    attr_reader :countries, :sources

    def initialize(options = {})
      super
      @q = options[:q]
      @type = options[:type].try(:downcase)
      @countries = options[:countries].try { |c| c.upcase.split(',') }
      @sources   = options[:sources].try { |s| s.upcase.split(',') } || []
      @sort = '_score,name.keyword'
      @name = options[:name]
      @address = options[:address]
      @fuzziness = options[:fuzziness].try(:to_i)
      @end_date = options[:end_date] if options[:end_date].present?
      @start_date = options[:start_date] if options[:start_date].present?
      @issue_date = options[:issue_date] if options[:issue_date].present?
      @expiration_date = options[:expiration_date] if options[:expiration_date].present?
    end

    private

    def generate_query(json)
      multi_fields = %i(alt_names name remarks title)
      json.query do
        json.bool do

          json.must do
            json.child! { generate_multi_match(json, multi_fields, @q) } if @q
          end if @q

          if @name
            generate_fuzzy_queries(json, %w(name.keyword alt_names.keyword), @name)
          end
          if @address
            generate_fuzzy_queries(json, %w(addresses.address addresses.city addresses.state addresses.postal_code addresses.country), @address)
          end

        end
      end if [@q, @name, @fuzziness, @address].any?
    end

    def generate_fuzzy_queries(json, fields, value)
      json.set! 'should' do
        json.child! { generate_multi_match(json, fields, value) }

        json.child! do
          json.multi_match do
            json.fields fields
            json.query value
            json.fuzziness @fuzziness
          end
        end if @fuzziness
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
