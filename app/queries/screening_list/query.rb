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
          end if @type || @sources.any?
          json.set! 'should' do
            json.child! { json.terms { json.set! 'addresses.country', @countries } }
            json.child! { json.terms { json.set! 'ids.country', @countries } }
            json.child! { json.terms { json.nationalities @countries } }
            json.child! { json.terms { json.citizenships @countries } }
          end if @countries
        end
      end if @countries || @type || @sources.any?
    end
  end
end
