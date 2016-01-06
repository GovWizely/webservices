class DataSources::CSVParser < DataSources::SVParser
  def initialize(csv_string)
    super(csv_string, ',')
  end
end
