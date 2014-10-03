class ParatureFaqQuery < Query
  def initialize(options)
    super
    @question = options[:question].downcase if options[:question].present?
    @answer = options[:answer].downcase if options[:answer].present?
    @countries = options[:countries].downcase.split(',') if options[:countries].present?
    @q = options[:q].downcase if options[:q].present?
    @industry = options[:industry].downcase if options[:industry].present?
    @update_date_start = options[:update_date_start] if options[:update_date_start].present?
    @update_date_end = options[:update_date_end] if options[:update_date_end].present?
  end

  def generate_query(json)
    multi_fields = %i(question answer industry)
    json.query do
      json.bool do
        json.must do |must_json|
          must_json.child! { must_json.match { must_json.answer @answer } } if @answer
          must_json.child! { must_json.match { must_json.question @question } } if @question
          must_json.child! { must_json.match { must_json.industry @industry } } if @industry
          must_json.child! { generate_multi_match(must_json, multi_fields, @q) } if @q
        end
      end
    end if @question || @answer || @industry || @q
  end

  def generate_filter(json)
    json.filter do
      json.bool do
        json.must do
          json.child! { json.terms { json.country @countries } } if @countries
          generate_date_range(json)
        end
      end
    end if @countries || @update_date_start || @update_date_end
  end

  def generate_date_range(json)
    if @update_date_start || @update_date_end
      json.child! do
        json.range do
          json.update_date do
            json.from @update_date_start if @update_date_start
            json.to @update_date_end if @update_date_end
          end
        end
      end
    end
  end
end
