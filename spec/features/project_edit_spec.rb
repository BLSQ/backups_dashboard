require "rails_helper"

feature 'Project edit' do
  let!(:project) { create(:missing_autobus_token_project) }

  background do
    login_with_oauth
    visit root_path
  end

  scenario 'I should be able to setup an autobus project' do
    click_link 'SETUP'
    expect(page).to have_content 'Edit project ' + project.name
    expect(page).to have_css('.autobus-instructions__header')
    fill_in :project_autobus_token, with: '12345'
    click_on 'Update Project'
    expect(current_path).to eq('/')
    within('.projects-list--configured') do
      expect(page).to have_content project.name
    end
  end
end
