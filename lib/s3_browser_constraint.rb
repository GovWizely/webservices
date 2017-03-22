class S3BrowserConstraint
  def matches?(request)
    request.fullpath.slice!('/s3_browser/buckets/')
    request.fullpath.slice!('upload/')
    request.fullpath.slice!('delete/')
    request.env['warden'].user(:user).approved_buckets.include?(request.fullpath)
  end
end
