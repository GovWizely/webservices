class DataSources::TSVParser < DataSources::SVParser
  def initialize(tsv_string)
    super(tsv_string, "\t")
  end
end
