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
      solutions = []
      regulations.each do |regulation|
        agent.get(
          get_url(issue_name, regulation),
          [],
          agent.page.uri,
          'X-Requested-With' => 'XMLHttpRequest',
        )
        html_doc = Nokogiri::HTML(clean_html(agent.page.body))
        solutions << option_labels(html_doc.css('select[name=solution] option'))
      end

      { regulations: regulations, solutions: solutions.flatten.uniq }
    end

    def all_issue_info
      issue_docs = Envirotech::Consolidated.search_for(sources: 'issues', size: 100)
      issue_ids_names = issue_docs[:hits].map { |d|  [d[:_source][:source_id], d[:_source][:name_english]] }
      Hash[issue_ids_names.map { |id, name| [id, lookup_issue(name)] }]
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
        .map { |o| o.children.to_s }
        .reject { |s| ['', 'Select An Option'].include?(s) }
    end
  end
end
