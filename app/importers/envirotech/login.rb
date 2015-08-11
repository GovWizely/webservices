module Envirotech
  class Login
    LOGIN_URL = 'https://admin.export.gov/site_login'
    cattr_accessor :web_auth, :username, :password, :mechanize_agent

    class << self
      def mechanize_agent
        @@mechanize_agent ||= Mechanize.new
      end

      def headless_login
        token_form = mechanize_agent.get(LOGIN_URL).form
        token_form.password = web_auth

        # 1st login step using web auth.
        login_form = mechanize_agent.submit(token_form, token_form.buttons.first).form
        if login_form.present? # if the session is saved no login form will be presented.
          login_form.field_with(name: 'user[email]').value = username
          login_form.field_with(name: 'user[password]').value = password

          # 2nd login step using username + password.
          # No need to do any actions in the returned page.
          mechanize_agent.submit(login_form, login_form.buttons.first)
        end
      end
    end
  end
end
