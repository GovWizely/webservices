class String
  def indexize
    tableize.tr('/', ':')
  end

  def typeize
    indexize.singularize.to_sym
  end

  def reformat_date(format)
    Date.strptime(self, format).to_s
  end
end
