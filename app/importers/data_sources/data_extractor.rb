module DataSources
  class DataExtractor
    attr_reader :data

    def initialize(resource)
      tempfile = resource_is_url?(resource) ? open(resource) : resource
      @data = extract_data(tempfile, resource)
    end

    private

    def resource_is_url?(resource)
      resource.is_a?(String) && resource.starts_with?('http')
    end

    def extract_data(tempfile, resource)
      if excel_file?(tempfile)
        Roo::Excel.new(resource_is_url?(resource) ? resource : tempfile.path, file_warning: :ignore).to_csv
      else
        tempfile.read
      end
    end

    def excel_file?(tempfile)
      tempfile.content_type == 'application/vnd.ms-excel'
    end
  end
end
