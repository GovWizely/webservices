class String
  def indexize
    tableize.tr('/', ':')
  end

  def typeize
    indexize.singularize.to_sym
  end

  def strip_tags
    ActionController::Base.helpers.strip_tags(self)
  end
end
