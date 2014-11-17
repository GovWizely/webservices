class ItaOfficeLocationQuery < Query
  setup_query(
    q:      %i(post office_name),
    query:  %i(city),
    filter: %i(country state),
    sort:   %i(post.sort),
    )

  def initialize(options)
    options[:country] = options[:countries] if options[:countries].present?
    super
    @country = options[:country].downcase.split(',') if options[:country].present?
    @state = options[:state].downcase.split(',') if options[:state].present?
  end

  def filter_from_fields(json, fields)
    json.filter do
      json.bool do
        json.must do
          fields[:filter].each do |field|
            search = send(field)
            json.child! { json.terms { json.set! field, search } } if search
          end
        end
      end
    end if fields[:filter].map { |f| send(f) }.any?
  end
end
