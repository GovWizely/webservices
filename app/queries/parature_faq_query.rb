class ParatureFaqQuery < Query


  def initialize(options)
    super(options)
 	@question = options[:question].downcase if options[:question].present?
 	@create_date = options[:create_date] if options[:create_date].present?
 	@update_date = options[:update_date] if options[:update_date].present?
 
  end

  def generate_query(json)
    json.query do
      generate_match(json, :question, @question) if @question
    end if @question 
  end


  def generate_filter(json)
    json.filter do
      json.bool do
        json.must do
          json.child! { json.term { json.create_date @create_date } } if @create_date
          json.child! { json.term { json.update_date @update_date } } if @update_date
        end
      end
    end
  end


  def generate_match(json, field, query, operator = :and)
    json.match do
      json.set! field do
        json.operator operator
        json.query query
      end
    end
  end

end