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


 	def initialize(resource = nil)
      if resource == nil
    	 @resource = "https://g1.parature.com/api/v1/28023/28026/Article/1/?_token_=S1z2KcL7rXq3m8NxP0xEdgWlTwLCcZjrAkPMhAFSrcg4rBzg5VAr0RLLchL35LJgjA7@KQunD7pkhTOQJ7tJIg=="
        @test = false
      else
        @resource = resource
        @test = true
      end
      @folder_source = "#{Rails.root}/data/parature_faqs/folders.csv"
  end


  def import
    article_count = 379
    pause_duration = 10
  	Rails.logger.info "Importing #{@resource}"

    if @test == false

  	 id = 1
  	 data = "["

  	 while id <= article_count do
      if ( id % 100 == 0)
        sleep pause_duration
      end

      begin
  		  @resource = "https://g1.parature.com/api/v1/28023/28026/Article/#{id}/?_token_=S1z2KcL7rXq3m8NxP0xEdgWlTwLCcZjrAkPMhAFSrcg4rBzg5VAr0RLLchL35LJgjA7@KQunD7pkhTOQJ7tJIg=="
  		  entry = Hash.from_xml(open(@resource)).to_json
      rescue 
        id += 1
        next
      end

  		data += ( entry + "," )
  		id += 1
  	 end

  	 data = data[0...-1]
  	 data += "]"
      doc = JSON.parse(data, symbolize_names: true)

    elsif @test == true
      doc = JSON.parse( open(@resource).read, symbolize_names: true )

    end

    # Write input JSON to local file for specs
    #File.open("spec/fixtures/parature_faqs/parature_faqs.json", 'w') {|file| file.write(JSON.pretty_generate(doc))}

    faqs = doc.map { |faq_hash| process_faq_info faq_hash }
    faqs = faqs.compact

    #Write output JSON to local file for specs
    #File.open("spec/fixtures/parature_faqs/importer_output.json", 'w') {|file| file.write(JSON.pretty_generate(faqs))}

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

    faq.delete :folders
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