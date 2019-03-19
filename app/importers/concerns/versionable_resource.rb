module VersionableResource

  extend ActiveSupport::Concern

  included do
    raise 'Includee must be Importable' unless ancestors.include?(Importable)
    send(:prepend, Prepend)
  end

  module Prepend
    def import
      if resource_changed?
        super
        update_metadata available_version
        Rails.logger.info "#{self.class.name}: resource updated, new data indexed."
      else
        touch_metadata
        Rails.logger.info "#{self.class.name}: resource unchanged, no new data indexed."
      end
    end
  end

  def initialize(resource = nil)
    @resource = resource || (defined?(self.class::ENDPOINT) && self.class.const_get(:ENDPOINT))

    # We want to call super if it exists, but it seems that if we haven't
    # defined initialize in the ancestor tree ourselves, ruby will call
    # Object's initialize, which fails as it expects no arguments, whereas
    # we typically pass 1 argument to importers' initialize. So, we try calling
    # super, and silently ignore ArgumentErrors.
    begin
      super
    rescue ArgumentError
    end
  end

  def loaded_resource
    return super if defined?(super)
    @loaded_resource ||= Array(@resource).map { |r| read_resource(r) }.join
  end

  def read_resource(r)
    resource_content = open(r).read
    detection = CharlockHolmes::EncodingDetector.detect resource_content
    CharlockHolmes::Converter.convert resource_content, detection[:encoding], 'UTF-8'
  end

  def available_version
    @available_version ||= Digest::SHA1.hexdigest(loaded_resource.to_s)
  end

  def stored_version
    model_class.find_or_create_metadata.version
  end

  def resource_changed?
    stored_version != available_version
  end

  delegate :stored_metadata, :update_metadata, :touch_metadata, to: :model_class
end
