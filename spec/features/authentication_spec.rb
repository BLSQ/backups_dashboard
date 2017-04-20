require "rails_helper"

feature 'User login' do
  scenario 'Login via google_oauth2' do
    login_with_oauth
    expect(page).to have_content(/Sign Out/i)
  end
end
