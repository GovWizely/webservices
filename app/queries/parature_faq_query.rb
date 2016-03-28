class ParatureFaqQuery < Query
  def initialize(options)
    super
    @question = options[:question].downcase if options[:question].present?
    @answer = options[:answer].downcase if options[:answer].present?
    @q = options[:q].downcase if options[:q].present?

    @update_date = options[:update_date] if options[:update_date].present?

    @countries = options[:countries].downcase.split(',') if options[:countries].present?
    @industries = options[:industries].downcase.split(',') if options[:industries].present?
    @topics = options[:topics].downcase.split(',') if options[:topics].present?
  end

  def generate_query(json)
    multi_fields = %i(question answer)
    json.query do
      json.bool do
        json.must do |must_json|
          must_json.child! { must_json.match { must_json.answer @answer } } if @answer
          must_json.child! { must_json.match { must_json.question @question } } if @question
          must_json.child! { generate_multi_match(must_json, multi_fields, @q) } if @q
        end
      end
    end if @question || @answer || @q
  end

  def generate_filter(json)
    json.filter do
      json.bool do
        json.must do
          json.child! { json.terms { json.country @countries } } if @countries
          generate_industries_filter(json) if @industries
          json.child! { json.terms  { json.topic @topics } } if @topics
          generate_date_range(json, 'update_date', @update_date) if @update_date
        end
      end
    end if @countries || @industries || @topics || @update_date
  end

  def generate_industries_filter(json)
    json.child! do
      json.bool do
        json.set! 'should' do
          json.child! { json.terms  { json.industry @industries } }
          json.child! { json.terms  { json.ita_industries @industries } }
        end
      end
    end if @industries
  end
end
