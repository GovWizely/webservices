require 'active_support/concern'

module Searchable
  extend ActiveSupport::Concern

  COMMON_PARAMS = [:format, :size, :offset].freeze

  included do
    class_eval do
      class_attribute :search_klass, :search_params, instance_writer: false

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
    @search = search_klass.search_for params.permit(search_params).except(:format)
    render
  end
end
