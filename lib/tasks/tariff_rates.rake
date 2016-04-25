namespace :tariff_rates do
  desc 'Create TPP tariff rates endpoint'
  task tpp_rates: :environment do
    country_hash = { "AU" => "Australia",
                     "BN" => "Brunei",
                     "CA" => "Canada",
                     "CL" => "Chile",
                     "JP" => "Japan",
                     "MY" => "Malaysia",
                     "MX" => "Mexico",
                     "NZ" => "New Zealand",
                     "PE" => "Peru",
                     "SG" => "Singapore",
                     "VN" => "Vietnam" }
    dictionary_template = File.read("#{Rails.root}/spec/fixtures/data_sources/tpp_rates.yaml")
    country_hash.each do |country_code, country_name|
      Rails.logger.debug "Beginning #{country_name} at #{Time.now} ..."
      dictionary = dictionary_template.sub('ISO2_COUNTRY_CODE', country_code)
      country_name_underscored = country_name.gsub(' ', '_')
      url = "https://s3.amazonaws.com/tariffs/FTA_#{country_name_underscored}_TPP.csv"
      id = "#{country_name_underscored.downcase}_tpp_rates:v1"
      DataSource.find(id, { _source_exclude: 'data' }).destroy if DataSource.exists?(id)
      data_extractor = DataSources::DataExtractor.new(url)
      data_source = DataSource.create(_id: id,
                                      published: true,
                                      version_number: 1,
                                      name: "#{country_name} TPP Rates",
                                      description: "#{country_name} TPP Rates",
                                      api: "#{country_name_underscored.downcase}_tpp_rates",
                                      data: data_extractor.data,
                                      url: url,
                                      dictionary: '')
      data_source.update(dictionary: DataSources::Metadata.new(dictionary).deep_symbolized_yaml)
      data_source.ingest
    end
    id = 'tpp_rates:v1'
    DataSource.find(id).destroy if DataSource.exists?(id)
    consolidated_data_source = DataSource.create(_id: id,
                                                 published: true,
                                                 version_number: 1,
                                                 name: "TPP Rates",
                                                 description: "TPP Rates",
                                                 api: "tpp_rates",
                                                 dictionary: '',
                                                 consolidated: true)
    consolidated_dictionary = File.read("#{Rails.root}/spec/fixtures/data_sources/consolidated_tpp_rates.yaml")
    consolidated_data_source.update(dictionary: consolidated_dictionary)
  end

  desc 'Audit TPP tariff rate counts'
  task audit_tpp_rates: :environment do
    countries = %w(Australia Brunei Canada Chile Japan Malaysia Mexico New_Zealand Peru Singapore Vietnam)
    countries.each do |country_name_underscored|
      Rails.logger.debug "Auditing #{country_name_underscored} at #{Time.now} ..."
      id = "#{country_name_underscored.downcase}_tpp_rates:v1"
      data_source = DataSource.find(id)
      ingest_sv_options = { converters: [->(f) { f ? f.squish : nil }], headers: true, skip_blanks: true }
      records = CSV.parse(data_source.data, ingest_sv_options)
      record_ids = records['ID']
      data_source.with_api_model do |api_model_klass|
        record_ids.each do |record_id|
          Rails.logger.debug "#{record_id} not found in #{country_name_underscored}" if api_model_klass.search(query: { match: { source_id: record_id } }).total == 0
        end
      end
    end
  end

  desc 'Create tariff rates endpoint'
  task tariff_rates: :environment do
    country_hash = {
      "SG" => "Singapore",
      "DO" => "Dominican Republic",
      "SV" => "El Salvador",
      "HN" => "Honduras",
      "MA" => "Morocco",
      "AU" => "Australia",
      "BH" => "Bahrain",
      "OM" => "Oman",
      "PE" => "Peru",
      "CR" => "Costa Rica",
      "NI" => "Nicaragua",
      "GT" => "Guatemala",
      "PA" => "Panama",
      "CL" => "Chile",
      "KR" => "Korea",
      "CO" => "Colombia" }
    dictionary_template = File.read("#{Rails.root}/spec/fixtures/data_sources/tariff_rates.yaml")
    country_hash.each do |country_code, country_name|
      Rails.logger.debug "Beginning #{country_name} at #{Time.now} ..."
      dictionary = dictionary_template.sub('ISO2_COUNTRY_CODE', country_code)
      country_name_underscored = country_name.gsub(' ', '_')
      url = "https://s3.amazonaws.com/tariffs/FTA_#{country_name_underscored}_Data.csv"
      id = "#{country_name_underscored.downcase}_tariff_rates:v1"
      DataSource.find(id, { _source_exclude: 'data' }).destroy if DataSource.exists?(id)
      data_extractor = DataSources::DataExtractor.new(url)
      data_source = DataSource.create(_id: id,
                                      published: true,
                                      version_number: 1,
                                      name: "#{country_name} Tariff Rates",
                                      description: "#{country_name} Tariff Rates",
                                      api: "#{country_name_underscored.downcase}_tariff_rates",
                                      data: data_extractor.data,
                                      url: url,
                                      dictionary: '')
      data_source.update(dictionary: DataSources::Metadata.new(dictionary).deep_symbolized_yaml)
      data_source.ingest
    end
    id = 'tariff_rates:v1'
    DataSource.find(id).destroy if DataSource.exists?(id)
    consolidated_data_source = DataSource.create(_id: id,
                                                 published: true,
                                                 version_number: 1,
                                                 name: "Tariff Rates",
                                                 description: "Tariff Rates",
                                                 api: "tariff_rates",
                                                 dictionary: '',
                                                 consolidated: true)
    consolidated_dictionary = File.read("#{Rails.root}/spec/fixtures/data_sources/consolidated_tariff_rates.yaml")
    consolidated_data_source.update(dictionary: consolidated_dictionary)
  end

  desc 'Audit tariff rate counts'
  task audit_tariff_rates: :environment do
    countries = ["Dominican Republic", "El Salvador", "Honduras", "Morocco", "Australia", "Bahrain", "Oman", "Peru", "Costa Rica", "Nicaragua", "Guatemala", "Panama", "Chile", "Korea", "Colombia", "Singapore", "Panama"]
    countries.each do |country_name|
      country_name_underscored = country_name.gsub(' ', '_')
      Rails.logger.debug "Auditing #{country_name} at #{Time.now} ..."
      id = "#{country_name_underscored.downcase}_tariff_rates:v1"
      data_source = DataSource.find(id)
      ingest_sv_options = { converters: [->(f) { f ? f.squish : nil }], headers: true, skip_blanks: true }
      records = CSV.parse(data_source.data, ingest_sv_options)
      record_ids = records['ID']
      data_source.with_api_model do |api_model_klass|
        record_ids.each do |record_id|
          Rails.logger.debug "#{record_id} not found in #{country_name}" if api_model_klass.search(query: { match: { source_id: record_id } }).total == 0
        end
      end
    end
  end
end
