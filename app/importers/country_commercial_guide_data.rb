class CountryCommercialGuideData
  include Importable

  URI = 'https://github.com/GovWizely/ccg.git'
  NAME = 'ccg'
  BRANCH = 'gh-pages'

  def initialize(resource = URI)
    @resource = resource
  end

  def import
    setup

    docs = Dir["#{@path}/source/**/*.yaml"].map do |yaml_file|
      country_level_info = extract_country_level_info(yaml_file)
      build_docs(country_level_info['entries'])
    end.flatten

    CountryCommercialGuide.index(docs)
  ensure
    teardown
  end

  private

  def setup
    if from_git?
      # :nocov:
      dir = Dir.mktmpdir
      g = Git.clone(URI, NAME, path: dir)
      g.checkout(BRANCH)
      @path = "#{dir}/#{NAME}"
      # :nocov:
    else
      @path = @resource
    end
  end

  def from_git?
    !!(@resource =~ /\.git$/)
  end

  def extract_country_level_info(yaml_file)
    yaml_content = YAML.load_file(yaml_file)
    @md_file = yaml_content['md_file']
    @pdf_title = yaml_content['pdf_title']
    @country = yaml_content['country']
    @pdf_url = yaml_content['pdf_url']
    @section_url_prefix = yaml_content['section_url_prefix']
    @date = /(\d{4}\-\d{2}\-\d{2})/.match(@md_file)[1]
    yaml_content
  end

  def build_docs(entries)
    entries.map do |entry|
      begin
        filename = "#{@path}/_posts/#{@country.downcase}/#{@date}-#{entry['section_id']}.md"
        fh = File.open(filename)
        2.times { fh.readline('---') }  # Get rid of Jekyll's "Front Matter".
        entry['content'] = fh.read
        build_doc(entry)
      rescue Errno::ENOENT, EOFError
        nil
      end
    end.compact
  end

  def build_doc(entry)
    sanitize_entry(pdf_title:     @pdf_title,
                   pdf_url:       @pdf_url,
                   pdf_section:   entry['section'],
                   pdf_chapter:   entry['chapter'],
                   section_title: (/Chapter [0-9]*: (.*)$/.match(entry['chapter'])[1]),
                   country:       lookup_country(@country),
                   section_url:   "#{@section_url_prefix}#{entry['section_id']}.html",
                   topic:         entry['section'],
                   industry:      entry['industry'],
                   content:       RDiscount.new(entry['content']).to_html)
  end

  def teardown
    FileUtils.remove_entry(@path) if @path && from_git?
    @path = nil
  end
end
