module ParamEncoder
  def self.encode(value)
    CGI.escape(value).gsub('+','%20')
  end
end