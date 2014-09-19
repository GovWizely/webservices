require 'open-uri'
require 'csv'

class ParatureFaqData
	include Importer

  COLUMN_HASH = {
      id: :id,
      Question: :question,
      Answer: :answer,
      Published: :published,
      Date_Created: :create_date,
      Date_Updated: :update_date,
      Rating: :user_rating,
      Folders: :folders
  }.freeze


 	def initialize
    	@resource = "https://g1.parature.com/api/v1/28023/28026/Article/1/?_token_=S1z2KcL7rXq3m8NxP0xEdgWlTwLCcZjrAkPMhAFSrcg4rBzg5VAr0RLLchL35LJgjA7@KQunD7pkhTOQJ7tJIg=="
      @folder_source = "#{Rails.root}/data/parature_faqs/folders.csv"
  end


  def import
    article_count = 379
    pause_duration = 5
  	Rails.logger.info "Importing #{@resource}"

  	id = 1
    #data = ""
  	data = "["

  	while id <= article_count do

      if ( id % 100 == 0)
        sleep pause_duration
      end

      begin
  		  @resource = "https://g1.parature.com/api/v1/28023/28026/Article/#{id}/?_token_=S1z2KcL7rXq3m8NxP0xEdgWlTwLCcZjrAkPMhAFSrcg4rBzg5VAr0RLLchL35LJgjA7@KQunD7pkhTOQJ7tJIg=="
  		  entry = Hash.from_xml(open(@resource)).to_json
      rescue 
        puts id
        id += 1
        next
      end

  		data += ( entry + "," )
  		id += 1

  	end

    puts id
  	data = data[0...-1]
  	data += "]"

    #File.open("/Users/tmh/Desktop/output.txt", 'a') {|file| file.write(data)}

    #File.open("/Users/tmh/Desktop/output.txt", "r") do |infile|
    #  while (line = infile.gets)
    #    data += line
    #  end
    #end 

    doc = JSON.parse(data, symbolize_names: true)

    faqs = doc.map { |faq_hash| process_faq_info faq_hash }
    #puts faqs.count
    faqs = faqs.compact
    #puts faqs.count

    ParatureFaq.index faqs

  end


  def process_faq_info(faq_hash)

    folder_hash = get_folder_info

    faq = remap_keys COLUMN_HASH, faq_hash[:Article]

    faq[:topic] = []
    faq[:industry] = []
    faq[:country] = []

    if faq[:folders][:ArticleFolder].class == Hash
      id = faq[:folders][:ArticleFolder][:id]
      if folder_hash[id][:type] != "n/a"
        type_symbol = folder_hash[id][:type].to_sym
        faq[type_symbol] << folder_hash[id][:name]
      end

    elsif faq[:folders][:ArticleFolder].class == Array
      faq[:folders][:ArticleFolder].each do |folder|
        id = folder[:id]
        if folder_hash[id][:type] != "n/a"
          type_symbol = folder_hash[id][:type].to_sym
          faq[type_symbol] << folder_hash[id][:name]
        end
      end
    end

    faq[:country] = faq[:country].map {|country| lookup_country(country) }

    faq[:answer] = Sanitize.clean(faq[:answer]) if faq[:answer]
    faq[:create_date] = Date.parse(faq[:create_date]) if faq[:create_date]
    faq[:update_date] = Date.parse(faq[:update_date]) if faq[:update_date]

    if faq[:published] == "true"
      faq
    else
      #puts "Not published:  " + faq[:id] 
    end
  end


  def get_folder_info
    keys = [:id, :name, :type]
    file = File.open(@folder_source, "rb")
    folder_hash = Hash.new
    folder_array = CSV.parse(file.read).map {|a| Hash[ keys.zip(a) ] }

    folder_array.each do |folder|
      folder_hash[folder[:id]] = folder
    end

    folder_hash
  end


end