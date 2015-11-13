require 'spec_helper'

RSpec.feature 'Data Source management' do
  context 'with an admin user' do
    before { create_user(email: 'test@gov.gov', admin: true) }

    scenario 'admin user visits home page' do
      visit '/'

      fill_in 'Email', with: 'test@gov.gov'
      fill_in 'Password', with: 'p4ssword'
      click_button 'Log in'
      expect(page).to have_text('Your API Key is')
      expect(page).to have_text('CSV APIs')

      click_link('+')
      expect(page).to have_text('New data source')
      fill_in 'Description', with: 'Not gonna work'
      attach_file('Path', "#{Rails.root}/spec/fixtures/data_sources/de_minimis_date.csv")
      click_button 'Create'
      expect(page).to have_text("Name can't be blank")
      expect(page).to have_text("Api can't be blank")

      fill_in 'Name', with: 'Some human readable name'
      fill_in 'Description', with: 'Some human readable desc'
      fill_in 'Api', with: 'test_currencies'
      attach_file('Path', "#{Rails.root}/spec/fixtures/data_sources/de_minimis_date.csv")
      click_button 'Create'
      expect(page).to have_text('Data source was successfully created. Review the schema and make any changes')
      expect(page).to have_text('Editing data source')
      expect(page).to have_field('Name', with: 'Some human readable name')

      fill_in 'Name', with: 'Some other human readable name'
      click_button 'Update'
      expect(page).to have_text('Data source was successfully updated and data uploaded.')
      expect(page).to have_text('Some other human readable name')

      click_link('Back')
      expect(page).to have_text('Some other human readable name')

      click_link('Some other human readable name')
      click_button('Delete')
      expect(page).to have_text('Dataset was successfully destroyed')
    end
  end
end
