require 'open-uri'
require 'csv'

class ParatureFaqData
  include Importable

  COLUMN_HASH = {
    id:           :id,
    Question:     :question,
    Answer:       :answer,
    Published:    :published,
    Date_Updated: :update_date,
    Folders:      :folders,
  }.freeze

  def initialize(resource = nil, folder_resource = nil)
    @resource = resource || "https://g1.parature.com/api/v1/28023/28026/Article/%d/?_token_=#{Rails.configuration.try(:parature_api_access_token)}"
    @folder_resource = folder_resource || "https://g1.parature.com/api/v1/28023/28026/ArticleFolder/?_token_=#{Rails.configuration.try(:parature_api_access_token)}&_pageSize_=100"
  end

  def import
    # Grab folder info to ensure up-to-date controlled terms are getting assigned to FAQs
    @folder_info = get_folder_info

    data = Array(1..379).map do |id|
      sleep 10 if id % 10 == 0 && should_throttle
      begin
        extract_hash_from_resource(id)
      rescue OpenURI::HTTPError, Errno::ENOENT => e
        raise unless error_permitted(e)
        nil
      end
    end.compact

    faqs = data.map { |faq_hash| process_faq_info(faq_hash) }.compact
    model_class.index(faqs)
  end

  private

  def error_permitted(error)
    @permitted_error_messages ||= [
      '404 Not Found',
      '500 Internal Server Error',
      'No such file or directory',
    ]
    @permitted_error_messages.count { |m| error.message =~ /#{m}/ } > 0
  end

  def extract_hash_from_resource(id)
    resource = @resource % id
    entry = Hash.from_xml(open(resource)).symbolize_keys
    entry[:Article].symbolize_keys!
    entry
  end

  def should_throttle
    @should_throttle ||= URI.parse(@resource % 1).scheme =~ /ftp|http/
  end

  def process_faq_info(faq_hash)
    faq = remap_keys COLUMN_HASH, faq_hash[:Article]
    return nil if faq[:published] != 'true'
    faq.delete :published
    faq[:topic] = []
    faq[:industry] = []
    faq[:country] = []

    faq = process_folder_fields(faq)
    return nil if faq[:topic].include?('GKC Content Training')

    faq.delete :folders
    process_addtional_fields(faq)

    faq
  end

  def process_addtional_fields(faq)
    faq[:ita_industries] = get_mapper_terms_from_array(faq[:topic])
    faq[:country] = faq[:country].map { |country| lookup_country(country) }.compact

    faq[:answer] &&= Nokogiri::HTML.fragment(faq[:answer]).inner_text.squish
    faq[:answer] &&= strip_nonascii(faq[:answer])
    faq[:question] &&= strip_nonascii(faq[:question])
    faq[:update_date] &&= Date.parse(faq[:update_date]).to_s
  end

  def process_folder_fields(faq)
    if faq[:folders]['ArticleFolder'].class == Hash
      id = faq[:folders]['ArticleFolder']['id']
      faq = replace_folder_fields(faq, id) if @folder_info[id][:type] != 'n/a'

    elsif faq[:folders]['ArticleFolder'].class == Array
      faq[:folders]['ArticleFolder'].each do |folder|
        id = folder['id']
        faq = replace_folder_fields(faq, id) if @folder_info[id][:type] != 'n/a'
      end
    end
    faq
  end

  def replace_folder_fields(faq, id)
    type_symbol = @folder_info[id][:type].to_sym
    faq[type_symbol] << @folder_info[id][:name]
    faq
  end

  def get_folder_info
    folder_hash = Hash.from_xml(open(@folder_resource))
    folders = folder_hash['Entities']['ArticleFolder']
    folder_info = {}
    folders.each do |folder|
      type = if folder['Parent_Folder']
               extract_type(folder['Parent_Folder']['ArticleFolder']['Name'])
             else
               'n/a'
             end
      folder_info[folder['id']] = { id: folder['id'], name: folder['Name'], type: type }
    end
    folder_info
  end

  def extract_type(folder_name)
    if folder_name == 'Topics' || folder_name == 'Categories'
      'topic'
    elsif folder_name == 'Industries'
      'industry'
    elsif folder_name == 'Countries'
      'country'
    else
      'n/a'
    end
  end

  def strip_nonascii(str)
    str.present? ? str.delete("^\u{0000}-\u{007F}").squish : nil
  end
end
