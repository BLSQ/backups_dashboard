require "rails_helper"

feature 'Missing config projects list' do
  background do

  end

  scenario 'Signing in with correct credentials' do
    visit root_path
    expect(page).to have_content /BlueSquare backups dashboard/i
  end
end
