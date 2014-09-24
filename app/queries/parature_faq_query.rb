class ParatureFaqQuery < Query


  def initialize(options)
    super(options)
 	  @question = options[:question].downcase if options[:question].present?
 	  @answer = options[:answer].downcase if options[:answer].present?
    @country = options[:country] if options[:country].present?
    @q = options[:q] if options[:q].present?
    @industry = options[:industry] if options[:industry].present?
    @sort = 'id'
  end

  def generate_query(json)
    multi_fields = %i(question answer industry)
    json.query do
      json.bool do
        json.must do |must_json|
          must_json.child! { must_json.match { must_json.answer @answer } } if @answer
          must_json.child! { must_json.match { must_json.question @question} } if @question
          must_json.child! { must_json.match { must_json.industry @industry} } if @industry
          must_json.child! { generate_multi_match(must_json, multi_fields, @q) } if @q
        end
      end
    end if @question || @answer || @industry || @q
  end


  def generate_filter(json)
    json.filter do
      json.bool do
        json.must do
          json.child! { json.term { json.country @country } } if @country
        end
      end
    end if @country
  end

end