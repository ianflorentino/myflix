require 'spec_helper'

feature 'User signs in' do
  background do
    User.create(email: "john@doe.com", full_name: "John Doe", password: "password")
  end
  scenario "with existing username" do
    visit sign_in_path
    fill_in "Email", with: 'john@doe.com'
    fill_in "Password", with: 'password'
    click_button "Sign In"
    expect(page).to have_content "You are logged in!"
  end
end