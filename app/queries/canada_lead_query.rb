class CanadaLeadQuery < Query
  attr_reader :title, :description, :industry, :specific_location, :q

  def initialize(options)
    super(options)
    [:title, :description, :industry, :specific_location, :q].each do |sym|
      instance_variable_set("@#{sym}", options[sym])
    end
    @sort = "end_date,publish_date,title.raw,contract_number"
  end

  private

  def generate_query(json)
    json.query do
      json.bool do
        json.must do
          json.child! do
            json.match do
              json.title @title
            end
          end if @title
          json.child! do
            json.match do
              json.description @description
            end
          end if @description
          json.child! do
            generate_multi_match(json, [:title, :description], @q)
          end if @q
        end
      end
    end if [@title, @description, @q].any?
  end

  def generate_filter(json)
    json.filter do
      json.bool do
        json.must do
          json.child! {
            json.query { json.match { json.industry @industry } }
          } if @industry
          json.child! {
            json.query { json.match { json.specific_location @specific_location } }
          } if @specific_location
        end
      end
    end if [@industry, @specific_location].any?
  end
end
