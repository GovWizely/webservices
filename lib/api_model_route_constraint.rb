class ApiModelRouteConstraint
  def matches?(request)
    !request.params[:version_number].include?('/')
  end
end
