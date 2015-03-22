module V2::TradeEvent
  class Query < ::CountryIndustryQuery
    attr_reader :sources

    def initialize(options = {})
      super
      @industries = options[:industries].split(',').map(&:strip) rescue nil
      @sources = options[:sources].upcase.split(',') rescue []
      @sort = '_score,start_date'
    end

    private

    def generate_query(json)
      generate_multi_query(
        json,
        %i(
          registration_title description event_name industries.keyword city
          venues.city venues.state venues.country
          contacts.first_name contacts.last_name contacts.person_title
        ),
      )
    end

    def generate_filter(json)
      json.filter do
        json.bool do
          json.must do
            json.child! { json.terms { json.source @sources } } if @sources.any?
            json.child! { json.terms { json.set! 'venues.country', @countries } } if @countries
            json.child! {
              json.bool {
                json.set! 'should' do
                  Array(@industries).each{ |ind|
                    json.child! {
                      json.query { json.match { json.set! 'industries.keyword', ind } }
                    }
                  }
                end
              }
            } if @industries
          end
        end
      end if @sources.any? || @countries || @industries
    end

  end
end
