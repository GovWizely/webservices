require 'open-uri'

class ParatureFaqData
	include Importer

 	def initialize
    	@resource = "https://g1.parature.com/api/v1/28023/28026/Article/1/?_token_=S1z2KcL7rXq3m8NxP0xEdgWlTwLCcZjrAkPMhAFSrcg4rBzg5VAr0RLLchL35LJgjA7@KQunD7pkhTOQJ7tJIg=="
  end


  def import
    article_count = 100
  	Rails.logger.info "Importing #{@resource}"
  	#doc = Nokogiri::XML(open(@resource))
  	id = 1
  	data = "["
  	doc = Hash.new


  	while id < article_count do

  		@resource = "https://g1.parature.com/api/v1/28023/28026/Article/#{id}/?_token_=S1z2KcL7rXq3m8NxP0xEdgWlTwLCcZjrAkPMhAFSrcg4rBzg5VAr0RLLchL35LJgjA7@KQunD7pkhTOQJ7tJIg=="
  		data += Hash.from_xml(open(@resource)).to_json
  		data += ","
  		id += 1

  		end

  		data = data[0...-1]
  		data += "]"

  		doc = JSON.parse(data, symbolize_names: true)


  		ParatureFaq.index doc

  	end

end