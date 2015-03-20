module V2::TradeLead
  class Query < ::Query
    attr_reader :countries, :sources

    def initialize(options = {})
      super
      @countries = options[:countries].upcase.split(',') rescue nil
      @sources   = options[:sources].upcase.split(',') rescue []
      @industries  = options[:industries].split(',').map(&:strip) rescue nil
      @q    = options[:q]
      @sort = @q ? '_score' : 'publish_date:desc,country:asc'
    end

    private

    def generate_query(json)
      multi_fields = %i(title description topic tags procurement_organization)
      json.query do
        json.bool do
          json.must do
            json.child! { generate_multi_match(json, multi_fields, @q) }
          end
        end
      end if @q
    end

    def generate_filter(json)
      json.filter do
        json.bool do
          json.must do
            json.child! { json.terms { json.source @sources } } if @sources.any?
            json.child! { json.terms { json.country @countries } } if @countries

            json.child! do
              json.bool do
                json.set! 'should' do
                  Array(@industries).each do |ind|
                    json.child! do
                      json.query { json.match { json.set! 'industry.keyword', ind } }
                    end
                  end
                end
              end
            end if @industries

          end
        end
      end if @countries || @sources.any? || @industries
    end
  end
end
