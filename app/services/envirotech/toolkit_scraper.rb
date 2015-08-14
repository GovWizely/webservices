module Envirotech
  class ToolkitScraper
    def initialize
      agent.get('https://new.export.gov/envirotech/toolkit')
    end

    def lookup_issue(issue_name)
      agent.get(
        url(issue_name),
        [],
        agent.page.uri,
        'X-Requested-With' => 'XMLHttpRequest',
      )

      html_doc = Nokogiri::HTML(clean_html(agent.page.body))

      regulations = option_labels(html_doc.css('select[name=regulation] option'))
      solutions = option_labels(html_doc.css('select[name=solution] option'))

      { regulations: regulations, solutions: solutions }
    end

    def all_issue_info
      issue_docs = Envirotech::Consolidated.search_for(sources: 'issues', size: 100)
      issue_names = issue_docs[:hits].map { |d| d[:_source][:name_english] }
      Hash[issue_names.map { |name| [name, lookup_issue(name)] }]
    end

    private

    def agent
      @agent ||= Mechanize.new
    end

    def url(issue_name)
      "https://new.export.gov/envirotech/toolkit?issue_submit=#{issue_name}"
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
