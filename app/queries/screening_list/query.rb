module ScreeningList
  class Query < ::Query
    attr_reader :countries, :sources

    def initialize(options = {})
      super
      @q = options[:q] if options[:q].present?
      @type = options[:type].downcase if options[:type].present?
      @countries = options[:countries].upcase.split(',') if options[:countries].present?
      @sources = options[:sources].present? ? options[:sources].upcase.split(',') : []
      @sort = '_score,name.sort'
    end

    private

    def generate_query(json)
      multi_fields = %i(alt_names name remarks title)
      json.query do
        json.bool do
          json.must do
            json.child! { generate_multi_match(json, multi_fields, @q) } if @q
          end
        end
      end if @q
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
