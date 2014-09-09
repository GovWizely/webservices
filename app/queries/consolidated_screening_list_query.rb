class ConsolidatedScreeningListQuery < Query
  attr_reader :countries

  def initialize(options={})
    super
    @q = options[:q] if options[:q].present?
    @sdn_type = options[:sdn_type].downcase if options[:sdn_type].present?
    @countries = options[:countries].upcase.split(',') if options[:countries].present?
    @sources = options[:sources].present? ? options[:sources].upcase.split(',') : []
    @sort = '_score,end_date:desc,id'
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
          json.child! { json.term { json.sdn_type @sdn_type } } if @sdn_type
          json.child! { json.terms { json.source @sources } } if @sources.any?
        end if @sdn_type || @sources.any?
        json.set! 'should' do
          json.child! { json.terms { json.set! 'addresses.country', @countries } }
          json.child! { json.terms { json.set! 'ids.country', @countries } }
          json.child! { json.terms { json.nationalities @countries } }
          json.child! { json.terms { json.citizenships @countries } }
        end if @countries
      end
    end if @countries || @sdn_type || @sources.any?
  end
end
