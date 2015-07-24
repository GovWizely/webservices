module Envirotech
  class BaseData
    private

    def fetch_data
      Envirotech::Login.headless_login
      page = 1
      result = []
      loop do
        page_data = JSON.parse(Envirotech::Login.mechanize_agent.get(@resource + "?page=#{page}").body)
        break if page_data.blank?
        result.concat(page_data)
        page += 1
      end
      result
    end
  end
end
