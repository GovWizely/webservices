class TradeArticleQuery < Query
  attr_reader :evergreen, :pub_date_start, :pub_date_end, :update_date_start, :update_date_end, :q

  def initialize(options)
    super
    [:pub_date_start, :pub_date_end, :update_date_start, :update_date_end, :q].each do |sym|
      instance_variable_set("@#{sym}", options[sym])
    end
    @evergreen = (options[:evergreen] == 'true') if options[:evergreen]
    @sort = :pub_date
  end

  private

  def generate_query(json)
    json.query do
      generate_multi_match(json, [:title, :content], @q)
    end if @q
  end

  def generate_filter(json)
    json.filter do
      json.bool do
        json.must do
          generate_date_range(json, 'pub_date')

          generate_date_range(json, 'update_date')

          json.child! do
            json.term do
              json.evergreen @evergreen
            end
          end if evergreen_set?
        end
      end
    end if has_filter_options?
  end

  private

  def generate_date_range(json, field_str)
    date_start = instance_variable_get("@#{field_str}_start")
    date_end = instance_variable_get("@#{field_str}_end")
    date_range_method = "#{field_str}_range?"
    json.child! do
      json.range do
        json.set! field_str.to_sym do
          json.from date_start if date_start
          json.to date_end if date_end
        end
      end
    end if send(date_range_method)
  end

  def has_filter_options?
    evergreen_set? || pub_date_range? || update_date_range?
  end

  def evergreen_set?
    @evergreen == true || @evergreen == false
  end

  def update_date_range?
    @update_date_start || @update_date_end
  end

  def pub_date_range?
    @pub_date_start || @pub_date_end
  end
end
