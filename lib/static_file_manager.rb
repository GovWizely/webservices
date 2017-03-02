require 'aws-sdk-core'

class StaticFileManager
  CREDENTIALS = Aws::Credentials.new(Rails.configuration.aws_credentials[:access_key_id], Rails.configuration.aws_credentials[:secret_access_key])

  def self.upload_all_files(search_class)
    s3_client = get_s3_client

    search_data = search_class.fetch_all[:hits]
    %w(csv tsv).each do |format|
      file_data = search_class.send("as_#{format}", search_data)
      s3_client.put_object(bucket: 'search-api-static-files', key: "#{search_class.to_s.underscore}.#{format}", body: file_data)
    end
  end

  def self.download_file(file_name)
    get_s3_client.get_object(bucket: 'search-api-static-files', key: file_name)
  end

  private

  def self.get_s3_client
    Aws::S3::Client.new(region: Rails.configuration.aws_credentials[:region], credentials: CREDENTIALS)
  end
end
