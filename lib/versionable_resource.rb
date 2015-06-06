module VersionableResource
  def initialize(resource = nil)
    @resource = resource || self.class.const_get(:ENDPOINT)
  end

  def loaded_resource
    @loaded_resource ||= open(@resource).read
  end

  def available_version
    @resource_version ||= Digest::SHA1.hexdigest(loaded_resource)
  end
end
