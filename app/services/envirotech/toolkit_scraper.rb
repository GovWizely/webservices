module Envirotech
  class ToolkitScraper
    def initialize
      agent.get('https://new.export.gov/envirotech/toolkit')
    rescue Mechanize::ResponseCodeError
    end

    def lookup_issue(issue_name)
      agent.get(
        get_url(issue_name),
        [],
        agent.page.uri,
        'X-Requested-With' => 'XMLHttpRequest',
      )

      html_doc = Nokogiri::HTML(clean_html(agent.page.body))

      regulations = option_labels(html_doc.css('select[name=regulation] option'))
      relations = {}
      regulations.each do |regulation|
        agent.get(
          get_url(issue_name, regulation),
          [],
          agent.page.uri,
          'X-Requested-With' => 'XMLHttpRequest',
        )
        html_doc = Nokogiri::HTML(clean_html(agent.page.body))
        relations[regulation] = option_labels(html_doc.css('select[name=solution] option')).flatten.uniq
      end

      relations
    end

    def all_issue_info
      html_doc = Nokogiri::HTML(agent.page.body)
      issue_names = option_labels(html_doc.css('select[name=issue] option'))
      Hash[issue_names.map { |issue_name| [issue_name, lookup_issue(issue_name)] }]
    rescue Mechanize::ResponseCodeError
      nil
    end

    private

    def agent
      @agent ||= Mechanize.new
    end

    def get_url(issue_name, regulation_name = nil)
      url = "https://new.export.gov/envirotech/toolkit?issue_submit=#{issue_name}"
      regulation_name.present? ? url + "&regulation_submit=#{regulation_name}" : url
    end

    def clean_html(body)
      body["$(\"#envirotech_select_boxes\").html('"] = ''
      body["')"] = ''
      body.gsub!("\t", '').gsub!("\n", '').gsub!('\\', '')
      body
    end

    def option_labels(options)
      options
        .map { |o| o.children.text }
        .reject { |s| ['', 'Select An Option'].include?(s) }
    end
  end
end
