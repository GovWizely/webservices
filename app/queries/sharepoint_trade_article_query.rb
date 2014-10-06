class SharepointTradeArticleQuery < Query

  def initialize(options)
    super(options)
    @title = options[:title].downcase if options[:title].present?
    @short_title = options[:short_title].downcase if options[:short_title].present?
    @summary = options[:summary].downcase if options[:summary].present?
    @creation_date_start = options[:creation_date_start] if options[:creation_date_start].present?
    @creation_date_end = options[:creation_date_end] if options[:creation_date_end].present?
    #@release_date_start = 
    #@release_date_end = 
    #@expiration_date_start = 
    #@expiration_date_end = 
  end


  def generate_query(json)
    #multi_fields = %i(question answer industry)
    json.query do
      json.bool do
        json.must do |must_json|
          must_json.child! { must_json.match { must_json.title @title } } if @title
          must_json.child! { must_json.match { must_json.short_title @short_title } } if @short_title
          must_json.child! { must_json.match { must_json.summary @summary } } if @summary
        end
      end
    end if @title || @short_title || @summary
  end

  def generate_filter(json)
    json.filter do
      json.bool do
        json.must do
          #json.child! { json.terms { json.country @countries } } if @countries
          generate_date_range(json, "creation_date")
        end
      end
    end if has_filter_options?
  end

  def generate_date_range(json, date_str)
    date_start = instance_variable_get("@#{date_str}_start")
    date_end = instance_variable_get("@#{date_str}_end")
    if date_start || date_end
      json.child! do
        json.range do
          json.set! date_str.to_sym do
            json.from date_start if date_start
            json.to date_end if date_end
          end
        end
      end
    end
  end

  def creation_date_range?
    @creation_date_start || @creation_date_end
  end

  def has_filter_options?
    creation_date_range?
  end

end
