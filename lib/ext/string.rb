class String
  def indexize
    tableize.tr('/', ':')
  end

  def typeize
    indexize.singularize
  end
end
