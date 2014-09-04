class ApiConstraint
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  def matches?(request)
    @default ||
      (request.headers['Accept'] &&
        request.headers['Accept'].include?("application/vnd.tradegov.webservices.v#{@version}"))
  end
end
