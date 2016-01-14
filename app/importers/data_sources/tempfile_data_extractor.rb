module DataSources
  class TempfileDataExtractor
    attr_reader :data

    def initialize(tempfile)
      if tempfile.content_type == 'application/vnd.ms-excel'
        @data = Roo::Excel.new(tempfile.path, file_warning: :ignore).to_csv
      else
        @data = tempfile.read
      end
    end
  end
end
