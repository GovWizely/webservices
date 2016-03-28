class ReservedApiValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add attribute, (options[:message] || 'exists in the codebase as an endpoint') if api_exists_in_codebase?(value)
  end

  def api_exists_in_codebase?(value)
    Rails.application.routes.routes.collect { |route| route.defaults[:controller] }.compact
         .select { |path| path.starts_with?('api/v') }.map { |path| path.split('/')[2] }.uniq.include?(value,)
  end
end
