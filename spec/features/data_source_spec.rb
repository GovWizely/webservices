require 'spec_helper'

RSpec.feature 'Data Source management' do
  context 'with an admin user' do
    before { create_user(email: 'test@gov.gov', admin: true) }

    scenario 'admin user creates, edits, and deletes an API' do
      visit '/'

      fill_in 'Email', with: 'test@gov.gov'
      fill_in 'Password', with: 'p4ssword'
      click_button('Log in')
      expect(page).to have_text('Your API Key is')
      expect(page).to have_text('CSV APIs')

      click_link('+')
      expect(page).to have_text('New data source')
      fill_in 'Description', with: 'Not gonna work'
      attach_file('Path', "#{Rails.root}/spec/fixtures/data_sources/de_minimis_date.csv")
      click_button('Create')
      expect(page).to have_text("Name can't be blank")
      expect(page).to have_text("Api can't be blank")

      fill_in 'Name', with: 'Some human readable name'
      fill_in 'Description', with: 'Some human readable desc'
      fill_in 'Api', with: 'success_cases'
      attach_file('Path', "#{Rails.root}/spec/fixtures/data_sources/de_minimis_date.csv")
      click_button('Create')
      expect(page).to have_text('Data source was successfully created. Review the schema and make any changes')
      expect(page).to have_text('Editing data source')
      expect(page).to have_field('Name', with: 'Some human readable name')
      expect(page).to have_field('Api', readonly: true)

      fill_in 'Name', with: 'Some other human readable name'
      click_button('Update')
      expect(page).to have_text('Data source was successfully updated and data uploaded.')
      expect(page).to have_text('Some other human readable name')

      click_link('Back')
      expect(page).to have_text('Some other human readable name (v1)')

      click_link('Some other human readable name (v1)')
      click_button('Delete')
      expect(page).to have_text('Dataset was successfully destroyed')
    end

    scenario 'admin user tries to create an already existing API' do
      visit '/'

      fill_in 'Email', with: 'test@gov.gov'
      fill_in 'Password', with: 'p4ssword'
      click_button 'Log in'

      click_link('+')
      fill_in 'Name', with: 'Some human readable name'
      fill_in 'Description', with: 'Some human readable desc'
      fill_in 'Api', with: 'already_exists'
      attach_file('Path', "#{Rails.root}/spec/fixtures/data_sources/de_minimis_date.csv")
      click_button('Create')

      click_link('+')
      fill_in 'Name', with: 'this is a dupe'
      fill_in 'Description', with: 'should reject it'
      fill_in 'Api', with: 'already_exists'
      attach_file('Path', "#{Rails.root}/spec/fixtures/data_sources/de_minimis_date.csv")
      click_button('Create')
      expect(page).to have_text("Api 'already_exists' already exists.")
    end

    scenario 'admin user iterates version of API' do
      visit '/'

      fill_in 'Email', with: 'test@gov.gov'
      fill_in 'Password', with: 'p4ssword'
      click_button 'Log in'

      click_link('+')
      fill_in 'Name', with: 'Iterate Me'
      fill_in 'Description', with: 'Iterate Me desc'
      fill_in 'Api', with: 'nouns'
      attach_file('Path', "#{Rails.root}/spec/fixtures/data_sources/de_minimis_date.csv")
      click_button('Create')
      click_button('Update')
      expect(page).to have_text('Version: 1')

      click_link('Iterate API Version')
      expect(page).to have_text('New version of data source')
      expect(page).to have_field('Version', readonly: true, with: '2')
      attach_file('Path', "#{Rails.root}/spec/fixtures/data_sources/de_minimis_date.csv")
      click_button('Create')
      expect(page).to have_field('Version', readonly: true, with: '2')
      click_button('Update')
      expect(page).to have_text('Version: 2')

      click_link('Iterate API Version')
      attach_file('Path', "#{Rails.root}/spec/fixtures/data_sources/de_minimis_date.csv")
      click_button('Create')
      click_button('Update')

      click_link('Iterate Me (v1)')
      expect(page).to have_text('Version: 1')
      expect(page).to have_button('Delete')
      expect(page).not_to have_link('Edit')
      expect(page).not_to have_link('Iterate API Version')

      click_link('Iterate Me (v2)')
      expect(page).to have_text('Version: 2')
      expect(page).not_to have_button('Delete')
      expect(page).not_to have_link('Edit')
      expect(page).not_to have_link('Iterate API Version')

      click_link('Iterate Me (v3)')
      expect(page).to have_text('Version: 3')
      expect(page).to have_button('Delete')
      expect(page).to have_link('Edit')
      expect(page).to have_link('Iterate API Version')
    end

    scenario 'admin user marks an API as published' do
      visit '/'

      fill_in 'Email', with: 'test@gov.gov'
      fill_in 'Password', with: 'p4ssword'
      click_button 'Log in'

      click_link('+')
      fill_in 'Name', with: 'Some new API'
      fill_in 'Description', with: 'Not published yet'
      fill_in 'Api', with: 'publishing_test'
      attach_file('Path', "#{Rails.root}/spec/fixtures/data_sources/de_minimis_date.csv")
      click_button('Create')
      click_button('Update')
      expect(page).to have_text('Published: false')

      click_link('Edit')
      check('Published')
      click_button('Update')
      expect(page).to have_text('Published: true')
    end
  end
end
