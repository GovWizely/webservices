module V2::TradeEvent
  class Query < ::CountryIndustryQuery
    #
    # NOTE: This is mostly duplicated code.
    #       Given the fact we'll remove V1 soon after V2 becomes default it might
    #       not make sense to work on unifying just now.
    #       ... I should know better. You can make fun of me when you read this comment
    #       years later.
    #

    attr_reader :sources

    def initialize(options = {})
      super
      @industries = options[:industries].split(',').map(&:strip) rescue nil
      @sources = options[:sources].upcase.split(',') rescue []
      @sort = '_score,start_date'
      # Just to be sure, at this point, that no
      # filtering/sorting/scoring is being done on @industry
      @industry = nil
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
            json.child! do
              json.bool do
                json.set! 'should' do
                  Array(@industries).each do |ind|
                    json.child! do
                      json.query { json.match { json.set! 'industries.keyword', ind } }
                    end
                  end
                end
              end
            end if @industries
          end
        end
      end if @sources.any? || @countries || @industries
    end
  end
end
