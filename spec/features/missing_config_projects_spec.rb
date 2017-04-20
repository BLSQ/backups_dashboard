require "rails_helper"

feature 'Projects list' do
  let!(:missing_autobus_token_project) { create(:missing_autobus_token_project) }
  let!(:pg_project) { create(:pg_project) }

  background do
    login_with_oauth
    visit root_path
  end

  scenario 'I should see the list of projects with missing' do
    within('.projects-list--missing-config') do
      expect(page).to have_content(missing_autobus_token_project.name)
    end
  end

  scenario 'I should see the list of configured projects with missing' do
    within('.projects-list--configured') do
      expect(page).to have_content(pg_project.name)
    end
  end
end
