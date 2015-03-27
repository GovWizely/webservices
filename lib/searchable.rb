require 'active_support/concern'

module Searchable
  extend ActiveSupport::Concern

  COMMON_PARAMS = [:format, :size, :offset, :api_key].freeze

  included do
    class_eval do
      class_attribute :api_version, :search_klass, :search_params, instance_writer: false

      self.api_version = name.match(/Api::V(\d+)::/) { |m| m[1] }
      parts = name.gsub(/Controller|Api::V\d+::/, '').split('::')
      parts[0] = parts[0].singularize
      self.search_klass = parts.join('::').constantize

      self.search_params = []
      search_by *COMMON_PARAMS
    end
  end

  module ClassMethods
    def search_by(*params)
      self.search_params |= params
    end
  end

  def search
    s = params.permit(search_params).except(:format)
    s.merge!(api_version: api_version)
    @search = search_klass.search_for s
    render
  end
end
