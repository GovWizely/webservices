class ParatureFaqQuery < Query


  def initialize(options)
    super(options)
 	@question = options[:question].downcase if options[:question].present?
 	#@sort = 'post.sort'
  end

  def generate_query(json)
    json.query do
      generate_match(json, :question, @question) if @question
    end if @question
  end


  def generate_filter(json)

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