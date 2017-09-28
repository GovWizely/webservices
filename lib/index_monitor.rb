class IndexMonitor
  MODEL_LIST = [
    'SalesforceArticle::CountryCommercial',
    'SalesforceArticle::Faq',
    'SalesforceArticle::MarketInsight',
    'ScreeningList::Dpl',
    'ScreeningList::Dtc',
    'ScreeningList::El',
    'ScreeningList::Eo13599',
    'ScreeningList::Fse',
    'ScreeningList::Isn',
    'ScreeningList::Part561',
    'ScreeningList::Plc',
    'ScreeningList::Sdn',
    'ScreeningList::Ssi',
    'ScreeningList::Uvl',
  ]

  def initialize(model_list = MODEL_LIST)
    Rails.logger.info 'Beginning index check...'
    @index_list = model_list.map { |model_name| model_name.constantize.index_name }
  end

  def check_indices
    errored_indices = []
    empty_indices = []
    @index_list.each do |index|
      metadata = get_metadata(index)
      if metadata[:last_imported].blank?
        empty_indices.push(index)
        next
      end
      actual_last_imported = DateTime.strptime(metadata[:last_imported], '%Y-%m-%dT%H:%M:%S%z')
      expected_last_imported = compute_expected_last_imported(metadata[:import_rate])

      if actual_last_imported < expected_last_imported
        errored_indices.push(index)
      end
    end

    if !errored_indices.empty? || !empty_indices.empty?
      raise "Indices need refresh: #{errored_indices}. Indices may be empty: #{empty_indices}."
    else
      Rails.logger.info 'All indices are up to date.'
    end
  end

  def compute_expected_last_imported(import_rate)
    expected_last_imported = DateTime.now.utc
    # Give one hour of buffer time for Importer jobs to finish:
    case import_rate
    when 'Hourly'
      expected_last_imported - 2.hours
    when 'Daily'
      expected_last_imported - 25.hours
    when 'Weekly'
      expected_last_imported - 169.hours
    end
  end

  def get_metadata(index)
    metadata = ES.client.get(
      index: index,
      type:  'metadata',
      id:    0,
    )['_source'].symbolize_keys
    if metadata[:import_rate] == ''
      raise "Index missing import rate:  #{index}"
    else
      return metadata
    end
  end
end
