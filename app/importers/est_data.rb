class EstData
  include Importer
  LOGIN_URL = 'https://admin.export.gov/site_login'
  ENDPOINT = 'https://admin.export.gov/admin/envirotech_solutions.json'

  cattr_accessor :web_auth, :username, :password

  COLUMN_HASH = {
    'id'              => :source_id,
    'name_chinese'    => :name_chinese,
    'name_english'    => :name_english,
    'name_french'     => :name_french,
    'name_portuguese' => :name_portuguese,
    'name_spanish'    => :name_spanish,
    'created_at'      => :source_created_at,
    'updated_at'      => :source_updated_at,
  }.freeze

  def initialize(resource = ENDPOINT)
    @resource = resource
  end

  def import
    data = JSON.parse(fetch_data)
    articles = data.map { |article_hash| process_article_info article_hash }

    Est.index articles
  end

  private

  def fetch_data
    headless_login
    mechanize_agent.get(@resource).body
  end

  def headless_login
    token_form = mechanize_agent.get(LOGIN_URL).form
    token_form.password = web_auth
    # 1st login step using web auth.
    login_form = mechanize_agent.submit(token_form, token_form.buttons.first).form
    login_form.field_with(name: 'user[email]').value = username
    login_form.field_with(name: 'user[password]').value = password
    # 2nd login step using username + password.
    mechanize_agent.submit(login_form, login_form.buttons.first) # No need to do any actions in the returned page.
  end

  def mechanize_agent
    @mechanize_agent ||= Mechanize.new
  end

  def process_article_info(article_hash)
    article = remap_keys COLUMN_HASH, article_hash

    %i(source_created_at source_updated_at).each do |field|
      article[field] &&= Date.parse(article[field]).iso8601 rescue nil
    end

    article[:id] = Utils.generate_id(article, %i(source_id name_english))
    sanitize_entry(article)
  end
end
