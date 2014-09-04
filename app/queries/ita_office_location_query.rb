class ItaOfficeLocationQuery < Query

  def initialize(options)
    super(options)
    @country = options[:country].downcase if options[:country].present?
    @city = options[:city].downcase if options[:city].present?
    if options[:state].present?
      @state = options[:state].downcase
      @country ||= 'us'
    end
    @q = options[:q] if options[:q].present?
    @sort = 'post.sort'
  end

  private

  def generate_query(json)
    json.query do
      generate_multi_match(json, [:post, :office_name], @q) if @q
      generate_match(json, :city, @city) if @city
    end if @q || @city
  end

  def generate_match(json, field, query, operator = :and)
    json.match do
      json.set! field do
        json.operator operator
        json.query query
      end
    end
  end

  def generate_filter(json)
    json.filter do
      json.bool do
        json.must do
          json.child! { json.term { json.country @country } } if country_search?
          json.child! { json.term { json.state @state } } if state_search?
        end
      end
    end if has_filter_options?
  end

  def has_filter_options?
    country_search? or state_search?
  end

  def country_search?
    @country
  end

  def state_search?
    @state and @country and @country == 'us'
  end
end
