desc 'Creates a dev admin user to access the api'
namespace :db do
  task devseed: :environment do
    user = User.create(email:                 'admin@rrsoft.co',
                       password:              'icanhazadmin2',
                       password_confirmation: 'icanhazadmin2',
                       company:               'Rapid River',
                       full_name:             'Admin I. Strator',
                       api_key:               'devkey',
                       confirmed_at:          Time.now.utc)
    puts user.errors.messages unless user.valid?
  end
end
