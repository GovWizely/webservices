desc 'Creates a dev admin user to access the api'
namespace :db do
  task devseed: :environment do
    user = User.create(email:                 'admin@example.co',
                       password:              '1nitial_pwd',
                       password_confirmation: '1nitial_pwd',
                       company:               'Example, Inc.',
                       full_name:             'Full Name',
                       api_key:               'devkey',
                       admin:                 true,
                       confirmed_at:          Time.now.utc,)
    puts user.errors.messages unless user.valid?
  end
end
