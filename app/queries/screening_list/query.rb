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
      @name = options[:name] if options[:name].present?
      @fuzziness = options[:fuzziness].to_i if options[:fuzziness].present?
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
            generate_name_queries(json, %w(name alt_names), @name)
          end

        end
      end if @q || @name || @fuzziness
    end

    def generate_name_queries(json, fields, value)
      json.set! 'should' do
        json.child! { generate_multi_match(json, fields, value) }

        json.child! do
          json.multi_match do
            json.fields fields
            json.query value
            json.fuzziness @fuzziness if @fuzziness
          end
        end
      end if @name || @fuzziness
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
