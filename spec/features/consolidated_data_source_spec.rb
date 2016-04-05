require 'spec_helper'

RSpec.feature 'Consolidated Data Source management' do
  context 'with an admin user' do
    before(:all) { @user = create_user(email: 'consolidated_test@gov.gov', admin: true) }

    scenario 'admin user creates a consolidated data source' do
      visit '/'

      fill_in 'Email', with: 'consolidated_test@gov.gov'
      fill_in 'Password', with: 'p4ssword'
      click_button 'Log in'

      click_link('+')
      fill_in 'Name', with: 'Testing feed1'
      fill_in 'Description', with: 'Testing feed1'
      fill_in 'Api', with: 'ab_entries'
      attach_file('Path', "#{Rails.root}/spec/fixtures/data_sources/feed1.csv")
      click_button('Create')
      click_button('Update')

      click_link('+')
      fill_in 'Name', with: 'Testing feed2'
      fill_in 'Description', with: 'Testing feed2'
      fill_in 'Api', with: 'cd_entries'
      attach_file('Path', "#{Rails.root}/spec/fixtures/data_sources/feed2.csv")
      click_button('Create')
      click_button('Update')

      click_link('><')
      expect(page).to have_text('New consolidated data source')
      fill_in 'Name', with: 'Testing consolidated feed'
      fill_in 'Description', with: 'Testing consolidated feed'
      fill_in 'Api', with: 'consolidated_entries'
      click_button('Create')

      fill_in 'Dictionary', with: "---\n- source: AB\n  api: ab_entries\n  version_number: 1\n- source: CD\n  api: cd_entries\n  version_number: 1\n"
      click_button('Update')

      visit("/v1/consolidated_entries/search.json?api_key=#{@user.api_key}&sources=AB,CD")
      expect(page).to have_text('here is some free text on ponies')
      expect(page).to have_text('this is about a pony')
      expect(page).to have_text('ponies are nice')
      expect(page).to have_text('horses are bigger')

      visit("/v1/consolidated_entries/search.json?api_key=#{@user.api_key}&sources=CD&q=pony")
      expect(page).not_to have_text('here is some free text on ponies')
      expect(page).not_to have_text('this is about a pony')
      expect(page).to have_text('ponies are nice')
      expect(page).not_to have_text('horses are bigger')
    end
  end
end
