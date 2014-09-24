class String
  def indexize
    self.tableize.tr('/', ':')
  end
  def typeize
    self.indexize.singularize
  end
end
