def build_user(args = {})
  defaults = { email:                 "rod#{Time.now.to_f + rand(1_000_000)}@example.com",
               password:              'p4ssword',
               password_confirmation: 'p4ssword',
               full_name:             'Rod',
               company:               "Rod's Corp",
               confirmed_at:          Time.now.utc,
               admin:                 false, }

  User.new(defaults.merge(args))
end

def create_user(args = {})
  u = build_user(args)
  u.save
  User.gateway.refresh_index!
  u
end
