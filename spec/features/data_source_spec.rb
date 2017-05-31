require 'spec_helper'

RSpec.feature 'Data Source management' do
  context 'with single data sources' do
    before(:all) do
      @user = create_user(email: 'test@gov.gov', admin: true)
      @non_admin_user = create_user(email: 'nonadmin@gov.gov', admin: false)
    end

    scenario 'admin user creates, edits, searches on, freshens, and deletes an API' do
      VCR.use_cassette('endpointme/sanity', record: :once) do
        visit '/'

        fill_in 'Email', with: 'test@gov.gov'
        fill_in 'Password', with: 'p4ssword'
        click_button('Log in')
        expect(page).to have_text('Your API Key is')
        expect(page).to have_text('Dynamic APIs')

        click_link('+')
        expect(page).to have_text('New data source')
        fill_in 'Description', with: 'Not gonna work'
        click_button('Create')
        expect(page).to have_text("Name can't be blank")
        expect(page).to have_text("Api can't be blank")

        fill_in 'Name', with: 'Some human readable name'
        fill_in 'Description', with: 'Some human readable desc'
        fill_in 'Api', with: 'success_cases'
        fill_in 'Url', with: 'https://s3.amazonaws.com/search-api-static-files/screening_list/feed2.csv'
        click_button('Create')
        expect(page).to have_text('Data source was successfully created. Review the dictionary and make any changes')
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
        click_link('Edit')
        fill_in 'Name', with: ''
        click_button('Update')
        expect(page).to have_text("Name can't be blank")

        visit("/v1/success_cases/search.json?api_key=#{@user.api_key}&q=pony")
        expect(page).to have_text('"col2":"ponies are nice"')

        visit("/v1/success_cases/freshen.json?api_key=#{@user.api_key}")
        expect(page).to have_text('"success":"success_cases:v1 API freshened"')

        visit '/'
        click_link('Some other human readable name (v1)')
        click_button('Delete')
        expect(page).to have_text('Dataset was successfully destroyed')
      end
    end

    scenario 'admin user tries to create an already existing API' do
      VCR.use_cassette('endpointme/api_already_exists', record: :once) do
        visit '/'

        fill_in 'Email', with: 'test@gov.gov'
        fill_in 'Password', with: 'p4ssword'
        click_button 'Log in'

        click_link('+')
        fill_in 'Name', with: 'Some human readable name'
        fill_in 'Description', with: 'Some human readable desc'
        fill_in 'Api', with: 'already_exists'
        fill_in 'Url', with: 'https://s3.amazonaws.com/trade-events/sba.json'
        click_button('Create')

        click_link('+')
        fill_in 'Name', with: 'this is a dupe'
        fill_in 'Description', with: 'should reject it'
        fill_in 'Api', with: 'already_exists'
        fill_in 'Url', with: 'https://s3.amazonaws.com/trade-events/sba.json'
        click_button('Create')
        expect(page).to have_text("Api 'already_exists' already exists.")
      end
    end

    scenario 'admin user iterates version of API' do
      VCR.use_cassette('endpointme/iterate', record: :once) do
        visit '/'

        fill_in 'Email', with: 'test@gov.gov'
        fill_in 'Password', with: 'p4ssword'
        click_button 'Log in'

        click_link('+')
        fill_in 'Name', with: 'Iterate Me'
        fill_in 'Description', with: 'Iterate Me desc'
        fill_in 'Api', with: 'nouns'
        fill_in 'Url', with: 'https://s3.amazonaws.com/trade-events/sba.json'
        click_button('Create')
        click_button('Update')
        expect(page).to have_text('Version: 1')

        click_link('Iterate API Version')
        expect(page).to have_text('New version of data source')
        expect(page).to have_field('Version', readonly: true, with: '2')
        fill_in 'Url', with: 'https://s3.amazonaws.com/trade-events/sba.json'
        click_button('Create')
        expect(page).to have_field('Version', readonly: true, with: '2')
        click_button('Update')
        expect(page).to have_text('Version: 2')

        click_link('Iterate API Version')
        fill_in 'Url', with: 'https://s3.amazonaws.com/trade-events/sba.json'
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
    end

    scenario 'admin user marks an API as unpublished' do
      VCR.use_cassette('endpointme/unpublish', record: :once) do
        visit '/'

        fill_in 'Email', with: 'test@gov.gov'
        fill_in 'Password', with: 'p4ssword'
        click_button 'Log in'

        click_link('+')
        fill_in 'Name', with: 'Some new API'
        fill_in 'Description', with: 'Not published yet'
        fill_in 'Api', with: 'publishing_test'
        fill_in 'Url', with: 'https://s3.amazonaws.com/trade-events/sba.json'
        click_button('Create')
        click_button('Update')
        expect(page).to have_text('Published: true')

        click_link('Edit')
        uncheck('Published')
        click_button('Update')
        expect(page).to have_text('Published: false')
      end
    end

    scenario 'non-admin tries to freshen an API' do
      VCR.use_cassette('endpointme/unauthorized', record: :once) do
        visit '/'

        fill_in 'Email', with: 'test@gov.gov'
        fill_in 'Password', with: 'p4ssword'
        click_button 'Log in'

        click_link('+')
        fill_in 'Name', with: 'Some new API'
        fill_in 'Description', with: 'Not published yet'
        fill_in 'Api', with: 'auth_test'
        fill_in 'Url', with: 'https://s3.amazonaws.com/search-api-static-files/screening_list/feed2.csv'
        click_button('Create')
        click_button('Update')

        visit '/'
        click_link('Logout')

        fill_in 'Email', with: 'nonadmin@gov.gov'
        fill_in 'Password', with: 'p4ssword'
        click_button('Log in')
        visit("/v1/auth_test/freshen.json?api_key=#{@non_admin_user.api_key}")
        expect(page).to have_text('Unauthorized.')
      end
    end

    scenario 'admin views endpoint me documentation' do
      VCR.use_cassette('endpointme/sanity', record: :once) do
        visit '/'

        fill_in 'Email', with: 'test@gov.gov'
        fill_in 'Password', with: 'p4ssword'
        click_button('Log in')
        expect(page).to have_text('Your API Key is')

        click_link('Endpoint Me Documentation')
        expect(page).to have_text('This section describes what is in this user guide.')
      end
    end
  end
end
