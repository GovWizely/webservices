require 'open-uri'

class ParatureFaqData
	include Importer

  COLUMN_HASH = {
      id: :id,
      Question: :question,
      Answer: :answer,
      Published: :published,
      Date_Created: :create_date,
      Date_Updated: :update_date,
      Rating: :user_rating
      #Folders: :category,
      #Folders: :topic,
      #Folders: :industry,
      #Folders: :country,
  }.freeze


 	def initialize
    	@resource = "https://g1.parature.com/api/v1/28023/28026/Article/1/?_token_=S1z2KcL7rXq3m8NxP0xEdgWlTwLCcZjrAkPMhAFSrcg4rBzg5VAr0RLLchL35LJgjA7@KQunD7pkhTOQJ7tJIg=="
  end


  def import
    article_count = 379
  	Rails.logger.info "Importing #{@resource}"

  	id = 241
    data = ""
  	#data += "["

  	#while id <= article_count do

    #  begin
  	#	  @resource = "https://g1.parature.com/api/v1/28023/28026/Article/#{id}/?_token_=S1z2KcL7rXq3m8NxP0xEdgWlTwLCcZjrAkPMhAFSrcg4rBzg5VAr0RLLchL35LJgjA7@KQunD7pkhTOQJ7tJIg=="
  	#	  entry = Hash.from_xml(open(@resource)).to_json
    #  rescue 
    #    id += 1
    #    next
    #  end

  	#	data += ( entry + "," )
  	#	id += 1

  	#end

    #puts id
  	#data = data[0...-1]
  	#data += "]"

    #File.open("/Users/tmh/Desktop/output.txt", 'a') {|file| file.write(data)}

    File.open("/Users/tmh/Desktop/output.txt", "r") do |infile|
      while (line = infile.gets)
        data += line
      end
    end 

    doc = JSON.parse(data, symbolize_names: true)

    faqs = doc.map { |faq_hash| process_faq_info faq_hash }
    puts faqs.count
    faqs = faqs.compact
    puts faqs.count

  	ParatureFaq.index faqs

  end


  def process_faq_info(faq_hash)
    faq = remap_keys COLUMN_HASH, faq_hash[:Article]

    faq[:answer] = Sanitize.clean(faq[:answer]) if faq[:answer]
    faq[:create_date] = Date.parse(faq[:create_date]) if faq[:create_date]
    faq[:update_date] = Date.parse(faq[:update_date]) if faq[:update_date]

    if faq[:published] == "true"
      faq
    else
      puts "Not published:  " + faq[:id] 
    end
  end

end