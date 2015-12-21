module VersionableResource
  # Add this concern to an Importable class to cause it to check if its source
  # changed before actually indexing any documents. You may have to overwrite
  # available_version, if SHA1-ing your source document body isn't going to
  # give you a reliable version of your source.

  extend ActiveSupport::Concern

  included do
    fail 'Includee must be Importable' unless ancestors.include?(Importable)
    send(:prepend, Prepend)
  end

  module Prepend
    def import
      if resource_changed? || self.class.const_defined?(:CONTAINS_MAPPER_LOOKUPS)
        super
        update_metadata(available_version)
        Rails.logger.info "#{self.class.name}: resource updated, new data indexed."
      else
        touch_metadata
        Rails.logger.info "#{self.class.name}: resource unchanged, no new data indexed."
      end
    end
  end

  def initialize(resource = nil)
    @resource = resource || self.class.const_get(:ENDPOINT)
  end

  def loaded_resource
    if @resource.is_a? Array
      @loaded_resource ||= @resource.map { |r| open(r).read }.join
    else
      @loaded_resource ||= open(@resource).read
    end
  end

  def available_version
    @resource_version ||= Digest::SHA1.hexdigest(loaded_resource)
  end

  private

  def stored_version
    model_class.stored_metadata[:version]
  end

  def resource_changed?
    stored_version != available_version
  end

  delegate :stored_metadata, :update_metadata, :touch_metadata, to: :model_class
end
